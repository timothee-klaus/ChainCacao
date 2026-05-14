"use client"

import { useState, useCallback } from "react"
import { toast } from "sonner"
import {
  fetchUsers,
  fetchPendingRegistrations,
  registerActorOnBlockchain,
  registerProducer,
  registerAgent,
} from "@/lib/services/actors.service"
import type {
  ApiUser,
  RegisterActorPayload,
  RegisterProducerPayload,
  RegisterAgentPayload,
  ActorType,
  OrgName,
  roleToOrg,
} from "@/types/api-actors"
import { roleToOrg as roleToOrgMap } from "@/types/api-actors"

interface UseActorsState {
  users: ApiUser[]
  pendingUsers: ApiUser[]
  isLoading: boolean
  isSubmitting: boolean
}

export function useActors() {
  const [state, setState] = useState<UseActorsState>({
    users: [],
    pendingUsers: [],
    isLoading: false,
    isSubmitting: false,
  })

  const setLoading = (isLoading: boolean) =>
    setState((s) => ({ ...s, isLoading }))

  const setSubmitting = (isSubmitting: boolean) =>
    setState((s) => ({ ...s, isSubmitting }))

  /** Charge tous les utilisateurs visibles par le rôle courant */
  const loadUsers = useCallback(async () => {
    setLoading(true)
    try {
      const users = await fetchUsers()
      setState((s) => ({ ...s, users, isLoading: false }))
    } catch (err: any) {
      toast.error(err.message || "Impossible de charger les utilisateurs")
      setLoading(false)
    }
  }, [])

  /** Charge les inscriptions en attente (Ministère uniquement) */
  const loadPendingRegistrations = useCallback(async () => {
    setLoading(true)
    try {
      const pendingUsers = await fetchPendingRegistrations()
      setState((s) => ({ ...s, pendingUsers, isLoading: false }))
    } catch (err: any) {
      toast.error(err.message || "Impossible de charger les inscriptions en attente")
      setLoading(false)
    }
  }, [])

  /** Valide un utilisateur sur la Blockchain */
  const validateOnBlockchain = useCallback(
    async (user: ApiUser) => {
      setSubmitting(true)
      try {
        const payload: RegisterActorPayload = {
          actorIdHash: user.blockchain_id || `USER-${user.id}`,
          typeActeur: user.role as ActorType,
          clePublique: `PUB-${user.id}-${Date.now()}`,
          orgName: roleToOrgMap[user.role as ActorType],
        }
        const result = await registerActorOnBlockchain(payload)
        if (result.success) {
          toast.success(`${user.full_name} validé sur la Blockchain`)
          // Mettre à jour la liste locale
          setState((s) => ({
            ...s,
            pendingUsers: s.pendingUsers.filter((u) => u.id !== user.id),
            users: s.users.map((u) =>
              u.id === user.id ? { ...u, blockchain_validated: true } : u
            ),
          }))
        }
      } catch (err: any) {
        toast.error(err.message || "Échec de la validation blockchain")
      } finally {
        setSubmitting(false)
      }
    },
    []
  )

  /** Inscrit un producteur via la Coopérative */
  const addProducer = useCallback(
    async (data: RegisterProducerPayload, onSuccess?: () => void) => {
      setSubmitting(true)
      try {
        const newUser = await registerProducer(data)
        setState((s) => ({ ...s, users: [newUser, ...s.users] }))
        toast.success(`Producteur ${newUser.full_name} inscrit avec succès`)
        onSuccess?.()
      } catch (err: any) {
        toast.error(err.message || "Échec de l'inscription du producteur")
      } finally {
        setSubmitting(false)
      }
    },
    []
  )

  /** Inscrit un agent (délégué, employé) */
  const addAgent = useCallback(
    async (data: RegisterAgentPayload, onSuccess?: () => void) => {
      setSubmitting(true)
      try {
        const newUser = await registerAgent(data)
        setState((s) => ({ ...s, users: [newUser, ...s.users] }))
        toast.success(`Agent ${newUser.full_name} inscrit avec succès`)
        onSuccess?.()
      } catch (err: any) {
        toast.error(err.message || "Échec de l'inscription de l'agent")
      } finally {
        setSubmitting(false)
      }
    },
    []
  )

  return {
    ...state,
    loadUsers,
    loadPendingRegistrations,
    validateOnBlockchain,
    addProducer,
    addAgent,
  }
}
