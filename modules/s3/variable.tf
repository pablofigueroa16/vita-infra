variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "versioning_enabled" {
  description = "Habilitar versionado"
  type        = bool
  default     = false
}

variable "server_side_encryption_configuration" {
  description = "Configuración de encriptación server-side"
  type = object({
    rule = object({
      apply_server_side_encryption_by_default = map(string)
      bucket_key_enabled                      = optional(bool)
    })
  })
  default = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

variable "block_public_acls" {
  description = "Bloquear ACLs públicos"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloquear políticas públicas"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignorar ACLs públicos"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringir buckets públicos"
  type        = bool
  default     = true
}

variable "cors_rules" {
  description = "Lista de reglas CORS"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "lifecycle_rules" {
  description = "Reglas de lifecycle"
  type        = list(any)
  default     = []
}

variable "logging_enabled" {
  description = "Habilitar logging"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Bucket destino para logs"
  type        = string
  default     = ""
}

variable "logging_target_prefix" {
  description = "Prefijo para logs"
  type        = string
  default     = "log/"
}

variable "enable_intelligent_tiering" {
  description = "Habilitar intelligent tiering"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionales"
  type        = map(string)
  default     = {}
}