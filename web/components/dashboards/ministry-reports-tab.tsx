"use client"
 
import { useLotsStore } from "@/store/lots"
import { useEUDRStore } from "@/store/eudr"
import { useActors } from "@/hooks/useActors"
import { KPICard } from "@/components/reports/kpi-card"
import { VolumeChart } from "@/components/reports/volume-chart"
import { QualityChart } from "@/components/reports/quality-chart"
import { 
  Globe, 
  ShieldCheck, 
  Users, 
  Landmark,
  FileBarChart
} from "lucide-react"
import { ChartConfig } from "@/components/ui/chart"
 
export function MinistryReportsTab() {
  const { lots } = useLotsStore()
  const { users } = useActors()
  const { getEUDRByExporter } = useEUDRStore()
 
  const totalVolume = lots.reduce((sum, l) => sum + (l.poidsKg || 0), 0)
  const coopsCount = users.filter(u => u.role === "COOPERATIVE").length
  
  // Aggregate volume by region
  const regionData: any[] = []
 
  const regionConfig = {
    volume: { label: "Volume (t)", color: "hsl(var(--primary))" },
  } satisfies ChartConfig
 
  const complianceData: any[] = []
 
  const complianceConfig = {
    conforme: { label: "Conforme EUDR", color: "#10b981" },
    nonConforme: { label: "Non Conforme / Suspect", color: "#ef4444" },
  } satisfies ChartConfig
 
  return (
    <div className="space-y-6 mt-4">
      {/* KPI Grid */}
      <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
        <KPICard 
          title="Volume National Exporté" 
          value={(totalVolume / 1000).toFixed(1)} 
          unit="t" 
          icon={Globe}
          trend={{ value: "+5.4%", positive: true }}
          colorVariant="blue"
        />
        <KPICard 
          title="Conformité EUDR" 
          value="85" 
          unit="%" 
          icon={ShieldCheck}
          trend={{ value: "+2.1%", positive: true }}
          colorVariant="emerald"
        />
        <KPICard 
          title="Coopératives Actives" 
          value={coopsCount} 
          icon={Landmark}
          trend={{ value: "Stable", stable: true }}
          colorVariant="amber"
        />
        <KPICard 
          title="Total Acteurs" 
          value={users.length} 
          icon={Users}
          trend={{ value: "+124", positive: true }}
          colorVariant="slate"
        />
      </div>
 
      {/* Charts Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <VolumeChart 
          title="Production par Région" 
          description="Répartition géographique de la collecte (Tonnage)"
          data={regionData}
          config={regionConfig}
          dataKeys={["volume"]}
        />
        <QualityChart 
          title="Statut Conformité National" 
          description="Taux de respect des normes EUDR sur l'ensemble des lots"
          data={complianceData}
          config={complianceConfig}
          centerValue="85%"
          centerLabel="Conforme"
        />
      </div>
    </div>
  )
}
