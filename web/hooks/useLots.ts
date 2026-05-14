"use client"

import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query"
import { lotService, type CreateLotPayload } from "@/lib/services/lot.service"
import { toast } from "sonner"
import { queryKeys } from "@/lib/query-keys"

export function useLots() {
  const queryClient = useQueryClient()

  // Fetch lots
  const { 
    data: serverLots = [], 
    isLoading, 
    refetch: loadLots 
  } = useQuery({
    queryKey: [queryKeys.lots],
    queryFn: () => lotService.getLots(),
  })

  // Create lot mutation
  const createLotMutation = useMutation({
    mutationFn: (payload: CreateLotPayload) => lotService.createLot(payload),
    onSuccess: (response, variables, context) => {
      toast.success("Lot de cacao créé et enregistré avec succès")
      queryClient.invalidateQueries({ queryKey: [queryKeys.lots] })
    },
    onError: (err: any) => {
      toast.error(err.message || "Erreur lors de la création du lot")
    },
  })

  return {
    serverLots,
    isLoading,
    isSubmitting: createLotMutation.isPending,
    loadLots,
    createLot: createLotMutation.mutateAsync,
  }
}

