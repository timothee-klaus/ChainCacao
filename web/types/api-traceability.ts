export type LotStatus = "COLLECTE" | "EN_TRANSIT" | "TRANSFORME" | "EXPORTE"

export interface HistoryEntry {
  txId: string
  timestamp: string
  isDelete: boolean
  value: {
    statut: LotStatus
    [key: string]: any
  }
}

export interface EUDRReport {
  success: boolean
  report_timestamp: string
  compliance_status: "COMPLIANT" | "NON_COMPLIANT" | "PENDING"
  access_level: "FULL" | "PARTIAL"
  data: {
    lot: Record<string, any>
    history: HistoryEntry[]
    certifications: Record<string, any>[]
  }
  proof_hash: string
}

export interface TransferPayload {
  transfer_hash: string
  lot_hashes: string[]
  expediteur_id: string
  destinataire_id: string
  preuve_hash: string
}

export interface TransformationPayload {
  transformation_hash: string
  lot_hashes: string[]
  type_processus: string
  preuve_hash: string
}

export interface ShipmentPayload {
  shipmentHash: string
  lotHashes: string[]
  exportateurId: string
  destination: string
  documentsHash: string
  dateDepartPrevue: string
  dateArriveePrevue: string
}

export interface VerificationResponse {
  lot_id: string
  product: string
  harvest_info: {
    date: string
    species: string
    weight: number
  }
  origin_photo: string
  journey: {
    step: LotStatus
    date: string
    txId: string
  }[]
  blockchain_verified: boolean
}
