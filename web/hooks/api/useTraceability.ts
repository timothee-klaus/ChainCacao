import { useMutation, useQueryClient } from "@tanstack/react-query"
import { api } from "@/lib/api"
import type {
  CreateTransferRequest,
  CreateTransformationRequest,
  CreateShipmentRequest,
  TransferEvent,
  ShipmentDetail,
} from "@/types/api"

// ============================================================================
// CREATE TRANSFER
// ============================================================================

export function useCreateTransferMutation() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateTransferRequest) => {
      return api.post<TransferEvent>("/api/v1/traceability/transfers", data)
    },
    onSuccess: () => {
      // Invalidate audit and lot queries
      queryClient.invalidateQueries({ queryKey: ["audit"] })
      queryClient.invalidateQueries({ queryKey: ["lots"] })
    },
  })
}

// ============================================================================
// CREATE TRANSFORMATION
// ============================================================================

export function useCreateTransformationMutation() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateTransformationRequest) => {
      return api.post("/api/v1/traceability/transformations", data)
    },
    onSuccess: () => {
      // Invalidate audit and lot queries
      queryClient.invalidateQueries({ queryKey: ["audit"] })
      queryClient.invalidateQueries({ queryKey: ["lots"] })
    },
  })
}

// ============================================================================
// CREATE SHIPMENT
// ============================================================================

export function useCreateShipmentMutation() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateShipmentRequest) => {
      return api.post<ShipmentDetail>("/api/v1/traceability/shipments", data)
    },
    onSuccess: () => {
      // Invalidate audit and lot queries
      queryClient.invalidateQueries({ queryKey: ["audit"] })
      queryClient.invalidateQueries({ queryKey: ["lots"] })
      queryClient.invalidateQueries({ queryKey: ["shipments"] })
    },
  })
}
