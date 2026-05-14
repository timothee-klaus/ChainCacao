"use client"

import { useLots } from "@/hooks/useLots"
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Skeleton } from "@/components/ui/skeleton"
import { useEffect } from "react"
import { Button } from "@/components/ui/button"
import { BarChart3, PieChart, FileText, Download, TrendingUp, Users } from "lucide-react"

export default function MinistryRapportsPage() {
  const { serverLots, loadLots, isLoading } = useLots()

  useEffect(() => {
    loadLots()
  }, [loadLots])

  const totalLots = serverLots.length
  const totalWeight = serverLots.reduce((sum, l) => sum + (l.poidsKg || l.poids_kg || 0), 0)
  const exportedWeight = serverLots.filter(l => l.statut === "exported").reduce((sum, l) => sum + (l.poidsKg || l.poids_kg || 0), 0)

  return (
    <div className="space-y-6 p-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="bg-primary/10 p-2 rounded-xl">
            <BarChart3 className="h-6 w-6 text-primary" />
          </div>
          <div>
            <h1 className="text-3xl font-bold">Rapports & Statistiques</h1>
            <p className="text-muted-foreground mt-1">Analyse globale de la production et des exportations.</p>
          </div>
        </div>
        <Button variant="outline" className="gap-2 rounded-xl">
          <Download className="h-4 w-4" />
          Exporter les données
        </Button>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        <Card className="bg-gradient-to-br from-indigo-500 to-indigo-700 text-white border-none">
          <CardContent className="p-6">
            <div className="flex items-center justify-between opacity-80 mb-4">
              <p className="text-sm font-medium uppercase tracking-wider">Volume Total</p>
              <TrendingUp className="h-5 w-5" />
            </div>
            <p className="text-3xl font-bold">{totalWeight.toLocaleString()} kg</p>
            <p className="text-xs mt-2 opacity-70">+12% par rapport au mois dernier</p>
          </CardContent>
        </Card>

        <Card className="bg-gradient-to-br from-emerald-500 to-emerald-700 text-white border-none">
          <CardContent className="p-6">
            <div className="flex items-center justify-between opacity-80 mb-4">
              <p className="text-sm font-medium uppercase tracking-wider">Part Exportée</p>
              <GlobeIcon className="h-5 w-5" />
            </div>
            <p className="text-3xl font-bold">{exportedWeight.toLocaleString()} kg</p>
            <p className="text-xs mt-2 opacity-70">{Math.round((exportedWeight/totalWeight)*100 || 0)}% du volume total</p>
          </CardContent>
        </Card>

        <Card className="bg-gradient-to-br from-amber-500 to-amber-700 text-white border-none">
          <CardContent className="p-6">
            <div className="flex items-center justify-between opacity-80 mb-4">
              <p className="text-sm font-medium uppercase tracking-wider">Acteurs Actifs</p>
              <Users className="h-5 w-5" />
            </div>
            <p className="text-3xl font-bold">1,284</p>
            <p className="text-xs mt-2 opacity-70">Producteurs, Coopératives, Exportateurs</p>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <PieChart className="h-5 w-5 text-primary" />
              Répartition par Région
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <RegionProgress label="Agnéby-Tiassa" value={45} color="bg-indigo-500" />
              <RegionProgress label="Gôh-Djiboua" value={30} color="bg-emerald-500" />
              <RegionProgress label="Bas-Sassandra" value={15} color="bg-amber-500" />
              <RegionProgress label="Autres" value={10} color="bg-slate-500" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <FileText className="h-5 w-5 text-primary" />
              Derniers Rapports Générés
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              <ReportItem title="Rapport Mensuel de Conformité EUDR" date="Mai 2026" />
              <ReportItem title="Statistiques d'Exportation - T1 2026" date="Avril 2026" />
              <ReportItem title="Audit de Traçabilité - Zone Ouest" date="Mars 2026" />
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

function RegionProgress({ label, value, color }: { label: string, value: number, color: string }) {
  return (
    <div className="space-y-1">
      <div className="flex justify-between text-sm">
        <span className="font-medium">{label}</span>
        <span className="text-muted-foreground">{value}%</span>
      </div>
      <div className="h-2 w-full bg-muted rounded-full overflow-hidden">
        <div className={`h-full ${color}`} style={{ width: `${value}%` }} />
      </div>
    </div>
  )
}

function ReportItem({ title, date }: { title: string, date: string }) {
  return (
    <div className="flex items-center justify-between p-3 rounded-xl border hover:bg-muted/30 transition-colors">
      <div className="min-w-0">
        <p className="font-medium text-sm truncate">{title}</p>
        <p className="text-xs text-muted-foreground">{date}</p>
      </div>
      <Button variant="ghost" size="icon" className="shrink-0">
        <Download className="h-4 w-4" />
      </Button>
    </div>
  )
}

function GlobeIcon(props: any) {
  return (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <circle cx="12" cy="12" r="10" />
      <line x1="2" y1="12" x2="22" y2="12" />
      <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
    </svg>
  )
}
