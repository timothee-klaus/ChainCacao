import { useUsersStore } from "@/store/users"

const BASE_URL = process.env.NEXT_PUBLIC_API_URL || "https://chaincacao-production-363c.up.railway.app"

type RequestOptions = {
  method?: string
  headers?: Record<string, string>
  body?: any
  isFormData?: boolean
}

async function request<T>(endpoint: string, options: RequestOptions = {}): Promise<T> {
  const { method = "GET", headers = {}, body, isFormData = false } = options

  const url = `${BASE_URL}${endpoint.startsWith("/") ? endpoint : `/${endpoint}`}`

  const requestHeaders: Record<string, string> = {
    "Accept": "application/json",
    ...headers,
  }

  // Add Authorization header if token exists
  // On récupère le token directement du store Zustand
  const state = useUsersStore.getState()
  const token = state.token
  
  if (token && token !== "null" && token !== "undefined") {
    requestHeaders["Authorization"] = `Bearer ${token}`
    if (process.env.NODE_ENV === 'development') {
      console.log(`[API] ${method} ${endpoint} - Token: ${token.substring(0, 10)}...`)
    }
  } else {
    console.warn(`[API] ${method} ${endpoint} - No valid token found in store`)
  }

  let requestBody = body

  if (body && !isFormData) {
    if (requestHeaders["Content-Type"] === "application/x-www-form-urlencoded") {
      requestBody = new URLSearchParams(body).toString()
    } else {
      requestHeaders["Content-Type"] = "application/json"
      requestBody = JSON.stringify(body)
    }
  }

  const response = await fetch(url, {
    method,
    headers: requestHeaders,
    body: requestBody,
  })

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}))
    throw new Error(errorData.detail || `HTTP error! status: ${response.status}`)
  }

  return response.json() as Promise<T>
}

export const api = {
  get: <T>(endpoint: string, options?: Omit<RequestOptions, "method" | "body">) =>
    request<T>(endpoint, { ...options, method: "GET" }),

  post: <T>(endpoint: string, body: any, options?: Omit<RequestOptions, "method" | "body">) =>
    request<T>(endpoint, { ...options, method: "POST", body }),

  put: <T>(endpoint: string, body: any, options?: Omit<RequestOptions, "method" | "body">) =>
    request<T>(endpoint, { ...options, method: "PUT", body }),

  delete: <T>(endpoint: string, options?: Omit<RequestOptions, "method" | "body">) =>
    request<T>(endpoint, { ...options, method: "DELETE" }),
}
