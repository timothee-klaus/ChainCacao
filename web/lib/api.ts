import { useUsersStore } from "@/store/users"

const BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://127.0.0.1:8000"

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
    ...headers,
  }

  // Add Authorization header if token exists
  const token = useUsersStore.getState().token
  if (token) {
    requestHeaders["Authorization"] = `Bearer ${token}`
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
