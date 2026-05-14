"use client"

import { useLots } from "@/hooks/useLots"
import { useEUDRStore } from "@/store/eudr"
import { useUser } from "@/context/useUser"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { ShieldAlert, Plus, Ship } from "lucide-react"
import Link from "next/link"
import { translateStatus } from "@/lib/status-helper"
import { useState, useEffect } from "react"
import { Skeleton } from "@/components/ui/skeleton"
import { useTraceability } from "@/hooks/useTraceability"
import { ShipmentDialog } from "@/components/traceability/shipment-dialog"
import { Checkbox } from "@/components/ui/checkbox"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"

export function ExporterDashboard() {
  const { user } = useUser()
  const { serverLots, loadLots, isLoading } = useLots()
  const { getEUDRByExporter } = useEUDRStore()
  const [selectedLots, setSelectedLots] = useState<string[]>([])

  useEffect(() => {
    loadLots()
  }, [loadLots])

  const readyToExport = serverLots.filter((l) => 
    ["transformed", "verified", "transforme"].includes(l.statut?.toLowerCase())
  )
  const eudrRecords = user ? getEUDRByExporter(user.userId) : []
  const confirmedCount = eudrRecords.filter((r) => r.status === "confirmed").length
  const pendingEudr = eudrRecords.filter((r) => r.status === "pending").length

  const toggleLot = (hash: string) => {
    setSelectedLots(prev => 
      prev.includes(hash) ? prev.filter(h => h !== hash) : [...prev, hash]
    )
  }

  const complianceRate = eudrRecords.length > 0
    ? Math.round((confirmedCount / eudrRecords.length) * 100)
    : 0

  return (
    <div className="space-y-6 p-6">
      {/* KPI Section */}
      <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
        <Card className="bg-gradient-to-br from-green-50 to-green-100 border-green-200">
          <CardHeader className="pb-2">
            <CardDescription className="text-green-700">Prêts à Exporter</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-green-900">{readyToExport.length}</div>
            <p className="text-xs text-green-700 mt-1">lots</p>
          </CardContent>
        </Card>

        <Card className="bg-gradient-to-br from-blue-50 to-blue-100 border-blue-200">
          <CardHeader className="pb-2">
            <CardDescription className="text-blue-700">Conformité EUDR</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-blue-900">{complianceRate}%</div>
            <p className="text-xs text-blue-700 mt-1">lots vérifiés</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardDescription>En Attente de Vérification</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-orange-600">{pendingEudr}</div>
            <p className="text-xs text-muted-foreground mt-1">lots</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardDescription>Total Confirmé</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold text-green-600">{confirmedCount}</div>
            <p className="text-xs text-muted-foreground mt-1">lots</p>
          </CardContent>
        </Card>
      </div>

      {/* Actions */}
      <div className="flex gap-2">
        <ShipmentDialog 
          lotHashes={selectedLots} 
          onSuccess={() => setSelectedLots([])} 
        />
        <Button variant="outline" asChild>
          <Link href="/exporter/conformite">
            <ShieldAlert className="h-4 w-4" />
            Vérifier EUDR
          </Link>
        </Button>
        <Button variant="ghost" asChild>
          <Link href="/exporter/historique">
            Voir l'historique
          </Link>
        </Button>
      </div>

      {/* Ready to Export Lots Table */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">Lots prêts pour l'expédition</CardTitle>
          <CardDescription>Sélectionnez les lots pour créer une expédition internationale</CardDescription>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="space-y-2">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-12"></TableHead>
                  <TableHead>Lot ID</TableHead>
                  <TableHead>Région</TableHead>
                  <TableHead>Poids (kg)</TableHead>
                  <TableHead>Statut</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {readyToExport.map((lot) => (
                  <TableRow key={lot.lotId || lot.id}>
                    <TableCell>
                      <Checkbox 
                        checked={selectedLots.includes(lot.lotId || lot.id)} 
                        onCheckedChange={() => toggleLot(lot.lotId || lot.id)}
                      />
                    </TableCell>
                    <TableCell className="font-mono text-xs">{lot.lotId || lot.id}</TableCell>
                    <TableCell>{lot.region}</TableCell>
                    <TableCell>{lot.poidsKg || lot.poids_kg}</TableCell>
                    <TableCell>
                      <Badge variant="secondary">{translateStatus(lot.statut)}</Badge>
                    </TableCell>
                  </TableRow>
                ))}
                {readyToExport.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center py-6 text-muted-foreground">
                      Aucun lot prêt pour l'export.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      {/* Recent EUDR Records */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">Verifications Récentes</CardTitle>
          <CardDescription>Dernières confirmations EUDR</CardDescription>
        </CardHeader>
        <CardContent>
          {eudrRecords.length > 0 ? (
            <div className="space-y-3">
              {eudrRecords.slice(-5).reverse().map((record) => (
                <div
                  key={record.shipmentId}
                  className="flex items-center justify-between border-b pb-3 last:border-0"
                >
                  <div className="flex-1">
                    <p className="font-medium text-sm">{record.shipmentId}</p>
                    <p className="text-xs text-muted-foreground">
                      {record.lotIds.length} lots • Score: {record.esgScore}
                    </p>
                  </div>
                  <Badge 
                    variant={record.status === "confirmed" ? "default" : "secondary"}
                  >
                    {translateStatus(record.status)}
                  </Badge>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-sm text-muted-foreground text-center py-4">
              Aucune vérification EUDR
            </p>
          )}
        </CardContent>
      </Card>

      {/* EUDR Compliance Info */}
      <Card className="border-amber-200 bg-amber-50">
        <CardHeader>
          <CardTitle className="text-lg flex items-center gap-2">
            <ShieldAlert className="h-5 w-5 text-amber-600" />
            Conformité EUDR
          </CardTitle>
        </CardHeader>
        <CardContent className="text-sm text-amber-900">
          <p>
            Assurez-vous que chaque lot respecte les exigences EUDR avant l'expédition.
            Utilisez l'outil de vérification pour confirmer la non-déforestation et la traçabilité complète.
          </p>
        </CardContent>
      </Card>
    </div>
  )
}
