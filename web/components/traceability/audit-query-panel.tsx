"use client"

import { useState } from "react"
import { Search } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { useAuditQueryStatus, useAuditQueryFarmer, useAuditQueryCertifications } from "@/hooks/useTraceability"

type SearchType = "status" | "farmer" | "certifications"

export function AuditQueryPanel() {
  const [searchType, setSearchType] = useState<SearchType>("status")
  const [inputValue, setInputValue] = useState("")
  const [activeSearch, setActiveSearch] = useState<{ type: SearchType; value: string } | null>(null)

  const handleSearch = () => {
    if (!inputValue) return
    setActiveSearch({ type: searchType, value: inputValue })
  }

  const { data: statusData, isLoading: isStatusLoading } = useAuditQueryStatus(
    activeSearch?.type === "status" ? activeSearch.value : ""
  )
  const { data: farmerData, isLoading: isFarmerLoading } = useAuditQueryFarmer(
    activeSearch?.type === "farmer" ? activeSearch.value : ""
  )
  const { data: certData, isLoading: isCertLoading } = useAuditQueryCertifications(
    activeSearch?.type === "certifications" ? activeSearch.value : ""
  )

  const isLoading = isStatusLoading || isFarmerLoading || isCertLoading
  const responseData =
    activeSearch?.type === "status"
      ? statusData
      : activeSearch?.type === "farmer"
      ? farmerData
      : certData

  const results = responseData?.success ? responseData.data : []

  return (
    <Card>
      <CardHeader>
        <CardTitle>Recherche d'Audit Avancée</CardTitle>
        <CardDescription>
          Interrogez directement la blockchain pour retrouver des lots selon différents critères.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="flex flex-col sm:flex-row gap-4">
          <Select
            value={searchType}
            onValueChange={(val: SearchType) => {
              setSearchType(val)
              setInputValue("")
              setActiveSearch(null)
            }}
          >
            <SelectTrigger className="w-full sm:w-[200px]">
              <SelectValue placeholder="Type de recherche" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="status">Par Statut</SelectItem>
              <SelectItem value="farmer">Par ID Producteur</SelectItem>
              <SelectItem value="certifications">Par Réf. Certification</SelectItem>
            </SelectContent>
          </Select>

          {searchType === "status" ? (
            <Select value={inputValue} onValueChange={setInputValue}>
              <SelectTrigger className="flex-1">
                <SelectValue placeholder="Sélectionnez un statut" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="COLLECTE">Collecté</SelectItem>
                <SelectItem value="EN_TRANSIT">En Transit</SelectItem>
                <SelectItem value="TRANSFORME">Transformé</SelectItem>
                <SelectItem value="EXPORTE">Exporté</SelectItem>
              </SelectContent>
            </Select>
          ) : (
            <Input
              placeholder={
                searchType === "farmer"
                  ? "Ex: FARMER-001"
                  : "Ex: CERT-ABC-123"
              }
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              className="flex-1"
              onKeyDown={(e) => e.key === "Enter" && handleSearch()}
            />
          )}

          <Button onClick={handleSearch} disabled={!inputValue || isLoading} className="gap-2">
            <Search className="h-4 w-4" />
            {isLoading ? "Recherche..." : "Rechercher"}
          </Button>
        </div>

        {activeSearch && (
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Lot ID</TableHead>
                  <TableHead>Espèce</TableHead>
                  <TableHead>Poids (kg)</TableHead>
                  <TableHead>Producteur</TableHead>
                  <TableHead>Statut</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isLoading ? (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                      Chargement des résultats depuis la blockchain...
                    </TableCell>
                  </TableRow>
                ) : results && results.length > 0 ? (
                  results.map((lot: any) => (
                    <TableRow key={lot.lotHash}>
                      <TableCell className="font-mono text-xs font-medium">
                        {lot.lotHash}
                      </TableCell>
                      <TableCell>{lot.espece}</TableCell>
                      <TableCell>{lot.poidsKg}</TableCell>
                      <TableCell>{lot.farmerId}</TableCell>
                      <TableCell>
                        <Badge variant="outline" className="capitalize">
                          {lot.statut}
                        </Badge>
                      </TableCell>
                    </TableRow>
                  ))
                ) : (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center py-8 text-muted-foreground">
                      Aucun lot ne correspond à vos critères de recherche.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
