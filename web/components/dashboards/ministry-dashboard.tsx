"use client"

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import Link from "next/link"
import { useLots } from "@/hooks/useLots"
import { useEffect } from "react"
import { Skeleton } from "@/components/ui/skeleton"

export function MinistryDashboard() {
  const { serverLots, loadLots, isLoading } = useLots()

  useEffect(() => {
    loadLots()
  }, [loadLots])

  const totalLots = serverLots.length
  const totalShipments = serverLots.filter(l => l.statut === "exported").length
  const complianceRate = totalLots > 0 ? 100 : 0 // À affiner selon les vrais critères EUDR

  return (
    <div className="space-y-6 p-6">
      <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardDescription>Lots Totaux</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">
              {isLoading ? <Skeleton className="h-9 w-16" /> : totalLots}
            </div>
            <p className="text-xs text-muted-foreground mt-1">lots tracés</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardDescription>Expéditions</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold">
              {isLoading ? <Skeleton className="h-9 w-16" /> : totalShipments}
            </div>
            <p className="text-xs text-muted-foreground mt-1">expéditions</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardDescription>Conformité EUDR</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-green-600">{complianceRate}%</div>
            <p className="text-xs text-muted-foreground mt-1">globale</p>
          </CardContent>
        </Card>
      </div>

      <div className="flex gap-2">
        <Button asChild>
          <Link href="/ministry/management">Gérer les acteurs</Link>
        </Button>
        <Button variant="outline" asChild>
          <Link href="/ministry/rapports">Voir les rapports</Link>
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-lg">Analyse Systématique</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">Consultez les rapports d'analyse et de conformité</p>
        </CardContent>
      </Card>
    </div>
  )
}
