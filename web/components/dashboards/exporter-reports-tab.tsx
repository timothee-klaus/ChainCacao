"use client"
 
import { useLotsStore } from "@/store/lots"
import { useEUDRStore } from "@/store/eudr"
import { KPICard } from "@/components/reports/kpi-card"
import { VolumeChart } from "@/components/reports/volume-chart"
import { QualityChart } from "@/components/reports/quality-chart"
import { 
  Ship, 
  ShieldCheck, 
  PackageCheck, 
  BarChart3,
  TrendingUp
} from "lucide-react"
import { ChartConfig } from "@/components/ui/chart"
import { useUser } from "@/context/useUser"
 
export function ExporterReportsTab() {
  const { lots } = useLotsStore()
  const { user } = useUser()
  const { getEUDRByExporter } = useEUDRStore()
 
  const eudrRecords = user ? getEUDRByExporter(user.userId) : []
  const confirmedCount = eudrRecords.filter(r => r.status === "confirmed").length
  
  const readyToExportVolume = lots
    .filter(l => ["transformed", "verified", "transforme"].includes(l.statut?.toLowerCase()))
    .reduce((sum, l) => sum + (l.poidsKg || 0), 0)
 
  const totalExportedVolume = lots
    .filter(l => ["exported", "exporte"].includes(l.statut?.toLowerCase()))
    .reduce((sum, l) => sum + (l.poidsKg || 0), 0)
 
  const shipmentData = [
    { month: "Jan", volume: 850 },
    { month: "Feb", volume: 1100 },
    { month: "Mar", volume: 980 },
    { month: "Apr", volume: 1250 },
    { month: "May", volume: 1400 },
    { month: "Jun", volume: 1150 },
  ]
 
  const shipmentConfig = {
    volume: { label: "Volume Expédié (t)", color: "hsl(var(--primary))" },
  } satisfies ChartConfig
 
  const statusData = [
    { name: "ready", value: 45, fill: "var(--color-ready)" },
    { name: "pending", value: 30, fill: "var(--color-pending)" },
    { name: "shipped", value: 25, fill: "var(--color-shipped)" },
  ]
 
  const statusConfig = {
    ready: { label: "Prêt à l'export", color: "#10b981" },
    pending: { label: "En transformation", color: "#f59e0b" },
    shipped: { label: "Expédié / En transit", color: "#3b82f6" },
  } satisfies ChartConfig
 
  return (
    <div className="space-y-6 mt-4">
      {/* KPI Grid */}
      <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
        <KPICard 
          title="Volume Prêt à l'Export" 
          value={(readyToExportVolume / 1000).toFixed(1)} 
          unit="t" 
          icon={PackageCheck}
          trend={{ value: "+18%", positive: true }}
          colorVariant="emerald"
        />
        <KPICard 
          title="Taux Conformité EUDR" 
          value={eudrRecords.length > 0 ? Math.round((confirmedCount / eudrRecords.length) * 100) : 0} 
          unit="%" 
          icon={ShieldCheck}
          trend={{ value: "Stable", stable: true }}
          colorVariant="blue"
        />
        <KPICard 
          title="Volume Total Expédié" 
          value={(totalExportedVolume / 1000).toFixed(1)} 
          unit="t" 
          icon={Ship}
          trend={{ value: "+5.2%", positive: true }}
          colorVariant="slate"
        />
        <KPICard 
          title="Valeur Estimée" 
          value="1.8M" 
          unit="$" 
          icon={TrendingUp}
          trend={{ value: "+12%", positive: true }}
          colorVariant="amber"
        />
      </div>
 
      {/* Charts Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <VolumeChart 
          title="Flux d'Expédition Mensuel" 
          description="Volume des sorties internationales (Tonnage)"
          data={shipmentData}
          config={shipmentConfig}
          dataKeys={["volume"]}
        />
        <QualityChart 
          title="Répartition par Statut" 
          description="État actuel de votre inventaire de lots"
          data={statusData}
          config={statusConfig}
          centerValue="100%"
          centerLabel="Inventaire"
        />
      </div>
    </div>
  )
}
