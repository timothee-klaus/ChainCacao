"use client"

import { useState } from "react"
import { useForm } from "react-hook-form"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { UserPlus } from "lucide-react"
import type { RegisterProducerPayload } from "@/types/api-actors"

interface RegisterProducerDialogProps {
  isSubmitting: boolean
  onSubmit: (data: RegisterProducerPayload, onSuccess: () => void) => void
}

type FormValues = {
  full_name: string
  numero_telephone: string
  email: string
  password: string
}

export function RegisterProducerDialog({
  isSubmitting,
  onSubmit,
}: RegisterProducerDialogProps) {
  const [open, setOpen] = useState(false)
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormValues>({
    defaultValues: { full_name: "", numero_telephone: "", email: "", password: "" },
  })

  const handleFormSubmit = (values: FormValues) => {
    const payload: RegisterProducerPayload = {
      full_name: values.full_name,
      password: values.password,
      ...(values.email && { email: values.email }),
      ...(values.numero_telephone && { numero_telephone: values.numero_telephone }),
    }
    onSubmit(payload, () => {
      reset()
      setOpen(false)
    })
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button size="sm" className="gap-1.5">
          <UserPlus className="size-4" />
          Inscrire un Producteur
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Inscrire un Producteur</DialogTitle>
          <DialogDescription>
            Créez un compte producteur directement depuis votre coopérative.
            L'email n'est pas obligatoire si vous renseignez un téléphone.
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit(handleFormSubmit)} className="space-y-4 py-2">
          <div className="space-y-1.5">
            <Label htmlFor="prod-fullname">Nom complet *</Label>
            <Input
              id="prod-fullname"
              placeholder="Kofi Amavi"
              {...register("full_name", { required: "Le nom est obligatoire" })}
            />
            {errors.full_name && (
              <p className="text-xs text-destructive">{errors.full_name.message}</p>
            )}
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="prod-phone">Téléphone</Label>
            <Input
              id="prod-phone"
              placeholder="+228 90 00 00 00"
              {...register("numero_telephone")}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="prod-email">Email</Label>
            <Input
              id="prod-email"
              type="email"
              placeholder="producteur@example.com"
              {...register("email")}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="prod-password">Mot de passe *</Label>
            <Input
              id="prod-password"
              type="password"
              placeholder="Min. 8 caractères"
              {...register("password", {
                required: "Le mot de passe est obligatoire",
                minLength: { value: 8, message: "Min. 8 caractères" },
              })}
            />
            {errors.password && (
              <p className="text-xs text-destructive">{errors.password.message}</p>
            )}
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => setOpen(false)}>
              Annuler
            </Button>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Inscription…" : "Inscrire"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}
