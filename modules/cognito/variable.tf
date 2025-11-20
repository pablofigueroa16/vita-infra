variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "password_minimum_length" {
  description = "Longitud mínima de contraseña"
  type        = number
  default     = 8
}

variable "password_require_lowercase" {
  description = "Requerir minúsculas"
  type        = bool
  default     = true
}

variable "password_require_uppercase" {
  description = "Requerir mayúsculas"
  type        = bool
  default     = true
}

variable "password_require_numbers" {
  description = "Requerir números"
  type        = bool
  default     = true
}

variable "password_require_symbols" {
  description = "Requerir símbolos"
  type        = bool
  default     = true
}

variable "mfa_configuration" {
  description = "Configuración de MFA"
  type        = string
  default     = "OPTIONAL"

  validation {
    condition     = contains(["OFF", "OPTIONAL", "ON"], var.mfa_configuration)
    error_message = "MFA debe ser OFF, OPTIONAL u ON"
  }
}

variable "email_verification_message" {
  description = "Mensaje de verificación de email"
  type        = string
  default     = "Tu código de verificación es {####}"
}

variable "email_verification_subject" {
  description = "Asunto del email de verificación"
  type        = string
  default     = "Verifica tu cuenta"
}

variable "enable_google_login" {
  description = "Habilitar login con Google"
  type        = bool
  default     = false
}

variable "google_client_id" {
  description = "Google OAuth Client ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "tags" {
  description = "Tags adicionales"
  type        = map(string)
  default     = {}
}