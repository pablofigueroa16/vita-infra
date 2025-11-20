variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "secrets" {
  description = "Mapa de secretos a crear"
  type = map(object({
    description         = string
    secret_string       = string
    rotation_enabled    = optional(bool, false)
    rotation_lambda_arn = optional(string)
    rotation_days       = optional(number, 30)
  }))
  default = {}
}

variable "tags" {
  description = "Tags adicionales"
  type        = map(string)
  default     = {}
}