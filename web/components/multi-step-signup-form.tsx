"use client"

import { Button } from "@/components/ui/button"
import {
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
} from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { useUser } from "@/context/useUser"
import { api } from "@/lib/api"
import {
  AVAILABLE_ROLES,
  registrationSchema,
  type RegistrationFormData,
} from "@/lib/schemas/registration"
import { cn } from "@/lib/utils"
import { useUsersStore } from "@/store/users"
import { User, UserRole } from "@/types/types"
import { useQuery } from "@tanstack/react-query"
import { zodResolver } from "@hookform/resolvers/zod"
import {
  Check,
  ChevronLeft,
  ChevronRight,
  Search,
  Upload,
  User as UserIcon,
} from "lucide-react"
import { AnimatePresence, motion } from "motion/react"
import { useRouter } from "next/navigation"
import { useState } from "react"
import { useForm } from "react-hook-form"
import { ScrollArea } from "./ui/scroll-area"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover"

type FormData = RegistrationFormData

const roleMapping: Record<string, UserRole> = {
  agriculteur: "Producteur / Agriculteur",
  "coop-manager": "Gestionnaire de Coopérative",
  transformer: "Transformateur",
  exporter: "Exportateur",
  "carrier-user": "Transporteur",
  verifier: "Vérificateur / Certificateur",
  importer: "Importateur",
  "ministry-analyst": "Analyste du Ministère",
}

export function MultiStepSignupForm({ className }: { className?: string }) {
  const [step, setStep] = useState(0)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const { addUser } = useUsersStore()
  const router = useRouter()
  const { setUser } = useUser()

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors },
    trigger,
  } = useForm<FormData>({
    resolver: zodResolver(registrationSchema),
    mode: "onBlur",
    defaultValues: {
      roles: [],
    },
  })

  const [coopSearch, setCoopSearch] = useState("")
  const [isCoopPopoverOpen, setIsCoopPopoverOpen] = useState(false)

  const { data: cooperatives, isLoading: isLoadingCoops } = useQuery({
    queryKey: ["cooperatives"],
    queryFn: async () => {
      try {
        const response = await api.get<any[]>("/api/v1/auth/users?role=COOPERATIVE")
        return response
      } catch (err) {
        console.error("Failed to fetch cooperatives (likely 401 protected endpoint):", err)
        return []
      }
    },
    retry: false,
    staleTime: 1000 * 60 * 5, // 5 minutes
  })

  const filteredCoops = cooperatives?.filter((coop) =>
    coop.full_name.toLowerCase().includes(coopSearch.toLowerCase())
  )

  const selectedRoles = watch("roles") || []

  const steps = [
    {
      title: "Informations personnelles",
      description: "Commençons par vos informations de base",
    },
    {
      title: "Créer un mot de passe",
      description: "Définissez un mot de passe sécurisé pour votre compte",
    },
    {
      title: "Sélectionnez votre rôle",
      description: "Choisissez votre rôle dans la chaîne d'approvisionnement",
    },
    {
      title: "Vérifier et terminer",
      description: "Vérifiez vos informations avant de créer votre compte",
    },
  ]

  const validateStep = async () => {
    const fieldsToValidate = getFieldsForStep(step)
    return await trigger(fieldsToValidate as any[])
  }

  const getFieldsForStep = (currentStep: number) => {
    switch (currentStep) {
      case 0:
        return ["nomAffiche", "email", "telephone"]
      case 1:
        return ["password", "confirmPassword"]
      case 2:
        const fields = ["roles"]
        if (selectedRoles.includes("agriculteur")) {
          fields.push("coopId")
        }
        return fields
      default:
        return []
    }
  }

  const handleNext = async () => {
    if (step < steps.length - 1) {
      const isValid = await validateStep()
      if (isValid) {
        setStep((prev) => prev + 1)
      }
    }
  }

  const handlePrevious = () => {
    if (step > 0) {
      setStep((prev) => prev - 1)
    }
  }

  const onSubmit = async (data: FormData) => {
    setIsSubmitting(true)
    setError(null)
    try {
      // Map frontend roles to backend roles
      const backendRoleMap: Record<string, string> = {
        agriculteur: "PRODUCTEUR",
        "coop-manager": "COOPERATIVE",
        transformer: "TRANSFORMATEUR",
        exporter: "EXPORTATEUR",
        "carrier-user": "EXPORTATEUR",
        verifier: "CERTIF",
        importer: "EXPORTATEUR",
        "ministry-analyst": "MINISTERE",
      }

      // Map backend roles to org names
      const orgMapping: Record<string, string> = {
        PRODUCTEUR: "producteurs",
        COOPERATIVE: "cooperatives",
        TRANSFORMATEUR: "transformateurs",
        EXPORTATEUR: "exportateurs",
        CERTIF: "certif",
        MINISTERE: "ministere",
      }

      const primaryRole = data.roles[0]
      const backendRole = backendRoleMap[primaryRole] || "PRODUCTEUR"
      const orgName = orgMapping[backendRole] || "producteurs"

      // Create FormData for multipart/form-data request
      const formData = new FormData()
      formData.append("email", data.email || "")
      formData.append("password", data.password)
      formData.append("full_name", data.nomAffiche)
      formData.append("role", backendRole)
      formData.append("numero_telephone", data.telephone || "")
      formData.append("org_name", orgName)

      if (data.coopId) {
        formData.append("coopId", data.coopId)
      }

      if (data.proofFile?.[0]) {
        formData.append("file", data.proofFile[0])
      } else {
        // Envoi d'un fichier vide pour éviter l'erreur 422 si le backend l'exige
        formData.append("file", new Blob([""], { type: "application/pdf" }), "empty.pdf")
      }

      const response = await api.post<{
        message: string
        user: {
          email: string
          full_name: string
          role: string
          org_name: string
          blockchain_id: string
        }
      }>("/api/v1/auth/register", formData, { isFormData: true })

      // After registration, the user might need to login to get a token,
      // but usually the backend might return a token or we just redirect to login.
      // The API_DOC doesn't say register returns a token.
      // Let's assume we redirect to login or handle it if the backend returns more.

      const newUser: User = {
        userId: response.user.blockchain_id || response.user.email,
        email: response.user.email,
        telephone: data.telephone || "",
        nomAffiche: response.user.full_name,
        roles: data.roles.map(
          (role) => roleMapping[role] || role
        ) as UserRole[],
        orgName: response.user.org_name,
        blockchainId: response.user.blockchain_id,
        statut: "actif",
        dateCreation: Date.now(),
        derniereConnexion: Date.now(),
      }

      setUser(newUser)
      addUser(newUser)

      // Since we don't have a token yet, we might want to redirect to login
      // or if the backend auto-logs in, we need that token.
      // For now, let's redirect to login to be safe, or just to the dashboard if the app allows it.
      router.push("/auth")
    } catch (err: any) {
      setError(err.message || "Échec de l'inscription. Veuillez réessayer.")
      console.error("Registration error:", err)
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className={cn("flex flex-col gap-6", className)}>
      {/* Progress Indicator */}
      <div className="flex justify-between">
        {steps.map((_, index) => (
          <motion.div
            key={index}
            className={cn(
              "flex h-10 w-10 items-center justify-center rounded-full border-2 font-semibold",
              index === step
                ? "border-primary bg-primary text-primary-foreground"
                : index < step
                  ? "border-primary bg-primary text-primary-foreground"
                  : "border-muted bg-muted text-muted-foreground"
            )}
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: index * 0.1 }}
          >
            {index < step ? <Check className="size-5" /> : index + 1}
          </motion.div>
        ))}
      </div>

      {/* Error Message */}
      {error && (
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="rounded-md bg-destructive/10 p-3 text-sm text-destructive"
        >
          {error}
        </motion.div>
      )}

      {/* Step Content */}

      <form onSubmit={handleSubmit(onSubmit)}>
        <ScrollArea className="h-[60vh]">
          <AnimatePresence mode="wait">
            <motion.div
              key={step}
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
            >
              {/* Step 0: Personal Information */}
              {step === 0 && (
                <FieldGroup>
                  <div className="gap-1 text-center">
                    <h2 className="text-xl font-bold">{steps[step].title}</h2>
                    <p className="text-sm text-muted-foreground">
                      {steps[step].description}
                    </p>
                  </div>

                  <Field>
                    <FieldLabel htmlFor="nomAffiche">Nom complet</FieldLabel>
                    <Input
                      id="nomAffiche"
                      type="text"
                      placeholder="Koffigan Dossou"
                      className="bg-background"
                      {...register("nomAffiche")}
                    />
                    {errors.nomAffiche && (
                      <p className="text-xs text-destructive">
                        {errors.nomAffiche.message}
                      </p>
                    )}
                  </Field>

                  <Field>
                    <FieldLabel htmlFor="email">E-mail</FieldLabel>
                    <Input
                      id="email"
                      type="email"
                      placeholder="m@example.com"
                      className="bg-background"
                      {...register("email")}
                    />
                    {errors.email && (
                      <p className="text-xs text-destructive">
                        {errors.email.message}
                      </p>
                    )}
                    <FieldDescription>
                      Nous utiliserons cet e‑mail pour vous contacter et
                      vérifier votre compte
                    </FieldDescription>
                  </Field>

                  <Field>
                    <FieldLabel htmlFor="telephone">
                      Numéro de téléphone
                    </FieldLabel>
                    <Input
                      id="telephone"
                      type="tel"
                      placeholder="+228 99 42 00 00"
                      className="bg-background"
                      {...register("telephone")}
                    />
                    {errors.telephone && (
                      <p className="text-xs text-destructive">
                        {errors.telephone.message}
                      </p>
                    )}
                  </Field>
                </FieldGroup>
              )}

              {/* Step 1: Password */}
              {step === 1 && (
                <FieldGroup>
                  <div className="gap-1 text-center">
                    <h2 className="text-xl font-bold">{steps[step].title}</h2>
                    <p className="text-sm text-muted-foreground">
                      {steps[step].description}
                    </p>
                  </div>

                  <Field>
                    <FieldLabel htmlFor="password">Mot de passe</FieldLabel>
                    <Input
                      id="password"
                      type="password"
                      className="bg-background"
                      {...register("password")}
                    />
                    {errors.password && (
                      <p className="text-xs text-destructive">
                        {errors.password.message}
                      </p>
                    )}
                    <FieldDescription>
                      Minimum 8 caractères, 1 lettre majuscule et 1 chiffre
                    </FieldDescription>
                  </Field>

                  <Field>
                    <FieldLabel htmlFor="confirmPassword">
                      Confirmer le mot de passe
                    </FieldLabel>
                    <Input
                      id="confirmPassword"
                      type="password"
                      className="bg-background"
                      {...register("confirmPassword")}
                    />
                    {errors.confirmPassword && (
                      <p className="text-xs text-destructive">
                        {errors.confirmPassword.message}
                      </p>
                    )}
                  </Field>
                </FieldGroup>
              )}

              {/* Step 2: Role Selection */}
              {step === 2 && (
                <FieldGroup>
                  <div className="gap-1 text-center">
                    <h2 className="text-xl font-bold">{steps[step].title}</h2>
                    <p className="text-sm text-muted-foreground">
                      {steps[step].description}
                    </p>
                  </div>

                  <div className="grid gap-3">
                    {AVAILABLE_ROLES.map((role) => (
                      <motion.label
                        key={role.id}
                        className="flex cursor-pointer items-start gap-3 rounded-lg border border-border p-3 transition-colors hover:bg-muted"
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                      >
                        <input
                          type="checkbox"
                          value={role.id}
                          {...register("roles")}
                          className="mt-1"
                        />
                        <div className="flex flex-col">
                          <span className="font-medium">{role.label}</span>
                          <span className="text-xs text-muted-foreground">
                            {role.description}
                          </span>
                        </div>
                      </motion.label>
                    ))}
                  </div>

                  {errors.roles && (
                    <p className="text-xs text-destructive">
                      {errors.roles.message}
                    </p>
                  )}

                  {/* Cooperative Selection for Farmers */}
                  {selectedRoles.includes("agriculteur") && (
                    <Field className="mt-4">
                      <FieldLabel>Votre Coopérative</FieldLabel>
                      <Popover
                        open={isCoopPopoverOpen}
                        onOpenChange={setIsCoopPopoverOpen}
                      >
                        <PopoverTrigger asChild>
                          <Button
                            variant="outline"
                            role="combobox"
                            className="w-full justify-between bg-background"
                          >
                            {watch("coopName") || "Sélectionnez une coopérative"}
                            <Search className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                          </Button>
                        </PopoverTrigger>
                        <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0">
                          <div className="flex flex-col">
                            <div className="flex items-center border-b p-2">
                              <Search className="mr-2 h-4 w-4 shrink-0 opacity-50" />
                              <input
                                placeholder="Rechercher une coopérative..."
                                className="h-9 w-full bg-transparent text-sm outline-none placeholder:text-muted-foreground"
                                value={coopSearch}
                                onChange={(e) => setCoopSearch(e.target.value)}
                              />
                            </div>
                            <ScrollArea className="h-60">
                              <div className="p-1">
                                {isLoadingCoops ? (
                                  <p className="p-2 text-center text-sm text-muted-foreground">
                                    Chargement...
                                  </p>
                                ) : filteredCoops?.length === 0 ? (
                                  <p className="p-2 text-center text-sm text-muted-foreground">
                                    Aucune coopérative trouvée.
                                  </p>
                                ) : (
                                  filteredCoops?.map((coop) => (
                                    <div
                                      key={coop.blockchain_id}
                                      className="flex cursor-pointer items-center gap-2 rounded-md p-2 text-sm hover:bg-muted"
                                      onClick={() => {
                                        setValue("coopId", coop.blockchain_id)
                                        setValue("coopName", coop.full_name)
                                        setIsCoopPopoverOpen(false)
                                      }}
                                    >
                                      <div className="flex h-8 w-8 items-center justify-center rounded-full bg-primary/10 text-primary">
                                        <UserIcon className="h-4 w-4" />
                                      </div>
                                      <div className="flex flex-col">
                                        <span className="font-medium">
                                          {coop.full_name}
                                        </span>
                                        <span className="text-xs text-muted-foreground">
                                          {coop.blockchain_id}
                                        </span>
                                      </div>
                                      {watch("coopId") ===
                                        coop.blockchain_id && (
                                        <Check className="ml-auto h-4 w-4" />
                                      )}
                                    </div>
                                  ))
                                )}
                              </div>
                            </ScrollArea>
                          </div>
                        </PopoverContent>
                      </Popover>
                      {errors.coopId && (
                        <p className="text-xs text-destructive">
                          {errors.coopId.message}
                        </p>
                      )}
                    </Field>
                  )}

                  {/* Proof File Upload */}
                  <Field className="mt-4">
                    <FieldLabel htmlFor="proofFile">
                      Preuve de légalité (PDF, Image)
                    </FieldLabel>
                    <div className="relative">
                      <Input
                        id="proofFile"
                        type="file"
                        className="hidden"
                        {...register("proofFile")}
                      />
                      <Button
                        type="button"
                        variant="outline"
                        className="w-full justify-start gap-2 border-dashed"
                        onClick={() =>
                          document.getElementById("proofFile")?.click()
                        }
                      >
                        <Upload className="h-4 w-4" />
                        {watch("proofFile")?.[0]?.name ||
                          "Choisir un document..."}
                      </Button>
                    </div>
                    <FieldDescription>
                      Requis pour validation par les autorités
                    </FieldDescription>
                  </Field>
                </FieldGroup>
              )}

              {/* Step 3: Review */}
              {step === 3 && (
                <FieldGroup>
                  <div className="gap-1 text-center">
                    <h2 className="text-xl font-bold">{steps[step].title}</h2>
                    <p className="text-sm text-muted-foreground">
                      {steps[step].description}
                    </p>
                  </div>

                  <motion.div
                    className="space-y-3 rounded-lg bg-muted p-4"
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.2 }}
                  >
                    <ReviewItem
                      label="Nom complet"
                      value={watch("nomAffiche")}
                    />
                    <ReviewItem label="E-mail" value={watch("email")} />
                    <ReviewItem label="Téléphone" value={watch("telephone")} />
                    {watch("coopName") && (
                      <ReviewItem
                        label="Coopérative"
                        value={watch("coopName")}
                      />
                    )}
                    <ReviewItem
                      label="Rôles"
                      value={selectedRoles
                        .map(
                          (role) =>
                            AVAILABLE_ROLES.find((r) => r.id === role)?.label
                        )
                        .join(", ")}
                    />
                  </motion.div>
                </FieldGroup>
              )}
            </motion.div>
          </AnimatePresence>
        </ScrollArea>

        {/* Navigation Buttons */}
        <div className="mt-8 flex justify-between gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={handlePrevious}
            disabled={step === 0}
          >
            <ChevronLeft className="size-4" />
            Précédent
          </Button>

          {step === steps.length - 1 ? (
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Création du compte..." : "Créer le compte"}
            </Button>
          ) : (
            <Button type="button" onClick={handleNext}>
              Suivant
              <ChevronRight className="size-4" />
            </Button>
          )}
        </div>
      </form>
    </div>
  )
}

function ReviewItem({ label, value }: { label: string; value?: string }) {
  return (
    <div className="flex justify-between py-1">
      <span className="text-sm font-medium text-muted-foreground">{label}</span>
      <span className="text-sm font-semibold">{value || "—"}</span>
    </div>
  )
}
