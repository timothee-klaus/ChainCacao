"use client"

import { useRouter } from "next/navigation"
import { useUser } from "@/context/useUser"
import { useLots } from "@/hooks/useLots"
import { useLotActionsStore } from "@/store/lot-actions"
import { EnhancedLotForm } from "@/components/forms/enhanced-lot-form"
import { Card } from "@/components/ui/card"
import type { LotFormData } from "@/lib/schemas/lot"

export default function NouveauLotPage() {
  const router = useRouter()
  const { user } = useUser()
  const { createLot, isSubmitting } = useLots()
  const { addAction } = useLotActionsStore()

  const handleSubmit = async (values: LotFormData, files: File[]) => {
    if (!user) return

    try {
      const lot = await createLot({
        espece: values.espece,
        poidsKg: values.poidsKg,
        dateCollecte: values.dateCollecte.toISOString(),
        region: values.region,
        gpsLatitude: values.gpsLatitude,
        gpsLongitude: values.gpsLongitude,
        coopName: values.coopName,
        photos: files,
      })

      // Optionnel : Enregistrer une action locale pour l'UI immédiate si besoin
      addAction({
        lotId: lot.id || "temp",
        actor: "Agriculteur",
        actorName: user.nomAffiche,
        actorId: user.userId,
        action: "created",
        phase: "recolte",
        status: "draft",
        description: "Enregistrement de récolte créé avec succès sur la blockchain.",
        metadata: {
          gps: { latitude: values.gpsLatitude, longitude: values.gpsLongitude },
          region: values.region,
          photos: files.length,
        },
      })
      router.push(`/agriculteur/lots`)
    } catch (error) {
      console.error("Error creating lot:", error)
    }
  }

  return (
    <div className="space-y-6 p-6">
      <div>
        <h1 className="text-3xl font-bold">Ajouter un Nouveau Lot</h1>
        <p className="text-muted-foreground mt-1">Remplissez les informations de votre lot agricole. La géolocalisation est détectée automatiquement.</p>
      </div>

      <Card className="p-6">
        <EnhancedLotForm
          onSubmit={handleSubmit}
          submitLabel="Créer le Lot"
          defaultValues={{
            espece: "",
            poidsKg: 0,
            region: "",
            coopName: "",
            gpsLatitude: 0,
            gpsLongitude: 0,
            dateCollecte: new Date(),
          }}
        />
      </Card>
    </div>
  )
}
