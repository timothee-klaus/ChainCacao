import { api } from "@/lib/api"
import type {
  HistoryEntry,
  EUDRReport,
  TransferPayload,
  TransformationPayload,
  ShipmentPayload,
  VerificationResponse,
} from "@/types/api-traceability"

export const traceabilityService = {
  getHistory: (assetHash: string) => 
    api.get<HistoryEntry[]>(`/api/v1/audit/history/${assetHash}`),
    
  verifyLot: (lotHash: string) => 
    api.get<VerificationResponse>(`/api/v1/audit/verify/${lotHash}`),
    
  getEUDRReport: (lotHash: string) => 
    api.get<EUDRReport>(`/api/v1/audit/eudr-report/${lotHash}`),
    
  createTransfer: (payload: TransferPayload) => 
    api.post<any>("/api/v1/traceability/transfers", payload),
    
  createTransformation: (payload: TransformationPayload) => 
    api.post<any>("/api/v1/traceability/transformations", payload),
    
  createShipment: (payload: ShipmentPayload) => 
    api.post<any>("/api/v1/traceability/shipments", payload),
}
