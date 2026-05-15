"use client"

import type React from "react"

import { ThemeProvider } from "@/components/theme-provider"
import { UserProvider } from "@/context/UserContext"
import { Toaster } from "@/components/ui/sonner"
import { QueryClientProvider } from "@tanstack/react-query"
import { queryClient } from "@/lib/query-client"

export function AppProviders({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <UserProvider>
          {children}
          <Toaster />
        </UserProvider>
      </ThemeProvider>
    </QueryClientProvider>
  )
}
