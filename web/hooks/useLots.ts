"use client"

import { useState, useCallback } from "react"
import { lotService, type CreateLotPayload } from "@/lib/services/lot.service"
import { toast } from "sonner"

export function useLots() {
  const [isLoading, setIsLoading] = useState(false)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [serverLots, setServerLots] = useState<any[]>([])

  const loadLots = useCallback(async () => {
    setIsLoading(true)
    try {
      const data = await lotService.getLots()
      setServerLots(data)
    } catch (err: any) {
      toast.error("Impossible de charger les lots du serveur")
    } finally {
      setIsLoading(false)
    }
  }, [])

  const createLot = async (payload: CreateLotPayload, onSuccess?: (lot: any) => void) => {
    setIsSubmitting(true)
    try {
      const response = await lotService.createLot(payload)
      toast.success("Lot de cacao créé et enregistré avec succès")
      onSuccess?.(response)
      return response
    } catch (err: any) {
      toast.error(err.message || "Erreur lors de la création du lot")
      throw err
    } finally {
      setIsSubmitting(false)
    }
  }

  return {
    serverLots,
    isLoading,
    isSubmitting,
    loadLots,
    createLot,
  }
}
