import { api } from "@/lib/api"

export interface CreateLotPayload {
  espece: string
  poidsKg: number
  dateCollecte: string
  region: string
  gpsLatitude: number
  gpsLongitude: number
  coopName?: string
  photos: File[]
}

export const lotService = {
  /**
   * Crée un nouveau lot de cacao (multipart/form-data)
   */
  createLot: async (payload: CreateLotPayload) => {
    const formData = new FormData()
    
    // Champs simples
    formData.append("espece", payload.espece)
    formData.append("poids_kg", payload.poidsKg.toString())
    formData.append("date_collecte", payload.dateCollecte)
    formData.append("region", payload.region)
    formData.append("gps_latitude", payload.gpsLatitude.toString())
    formData.append("gps_longitude", payload.gpsLongitude.toString())
    if (payload.coopName) formData.append("coop_name", payload.coopName)
    
    // Fichiers (photos)
    payload.photos.forEach((file, index) => {
      formData.append(`photos`, file)
    })

    // Note: On utilise fetch directement ou une instance axios configurée pour multipart
    // Ici on suppose que notre instance 'api' gère correctement les FormData
    return api.post<any>("/api/v1/lots/", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    })
  },

  getLots: () => api.get<any[]>("/api/v1/lots/"),
  
  getLot: (lotId: string) => api.get<any>(`/api/v1/lots/${lotId}`),
}
