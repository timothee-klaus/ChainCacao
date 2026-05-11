import { z } from "zod"

export const loginSchema = z.object({
  email: z.string().min(3, "Veuillez entrer un email ou un numéro de téléphone valide"),
  password: z
    .string()
    .min(1, "Password is required")
    .min(8, "Password must be at least 8 characters"),
})

export type LoginFormData = z.infer<typeof loginSchema>
