"use client"

import { useState } from "react"
import { toast } from "sonner"
import { traceabilityService } from "@/lib/services/traceability.service"
import type {
  HistoryEntry,
  EUDRReport,
  TransferPayload,
  VerificationResponse,
} from "@/types/api-traceability"

export function useTraceability() {
  const [history, setHistory] = useState<HistoryEntry[]>([])
  const [eudrReport, setEudrReport] = useState<EUDRReport | null>(null)
  const [verification, setVerification] = useState<VerificationResponse | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [isSubmitting, setIsSubmitting] = useState(false)

  const loadHistory = async (assetHash: string) => {
    setIsLoading(true)
    try {
      const data = await traceabilityService.getHistory(assetHash)
      setHistory(data)
    } catch (err: any) {
      toast.error(err.message || "Impossible de charger l'historique")
    } finally {
      setIsLoading(false)
    }
  }

  const loadEUDRReport = async (lotHash: string) => {
    setIsLoading(true)
    try {
      const data = await traceabilityService.getEUDRReport(lotHash)
      setEudrReport(data)
    } catch (err: any) {
      toast.error(err.message || "Impossible de charger le rapport EUDR")
    } finally {
      setIsLoading(false)
    }
  }

  const verifyLot = async (lotHash: string) => {
    setIsLoading(true)
    try {
      const data = await traceabilityService.verifyLot(lotHash)
      setVerification(data)
    } catch (err: any) {
      toast.error(err.message || "Erreur lors de la vérification du lot")
    } finally {
      setIsLoading(false)
    }
  }

  const createTransfer = async (payload: TransferPayload, onSuccess?: () => void) => {
    setIsSubmitting(true)
    try {
      await traceabilityService.createTransfer(payload)
      toast.success("Transfert enregistré avec succès sur la blockchain")
      onSuccess?.()
    } catch (err: any) {
      toast.error(err.message || "Échec de l'enregistrement du transfert")
    } finally {
      setIsSubmitting(false)
    }
  }

  const createTransformation = async (payload: TransformationPayload, onSuccess?: () => void) => {
    setIsSubmitting(true)
    try {
      await traceabilityService.createTransformation(payload)
      toast.success("Transformation enregistrée avec succès sur la blockchain")
      onSuccess?.()
    } catch (err: any) {
      toast.error(err.message || "Échec de l'enregistrement de la transformation")
    } finally {
      setIsSubmitting(false)
    }
  }

  const createShipment = async (payload: ShipmentPayload, onSuccess?: () => void) => {
    setIsSubmitting(true)
    try {
      await traceabilityService.createShipment(payload)
      toast.success("Expédition enregistrée avec succès sur la blockchain")
      onSuccess?.()
    } catch (err: any) {
      toast.error(err.message || "Échec de l'enregistrement de l'expédition")
    } finally {
      setIsSubmitting(false)
    }
  }

  return {
    history,
    eudrReport,
    verification,
    isLoading,
    isSubmitting,
    loadHistory,
    loadEUDRReport,
    verifyLot,
    createTransfer,
    createTransformation,
    createShipment,
  }
}
