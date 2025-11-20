variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "billing_mode" {
  description = "Modo de billing (PAY_PER_REQUEST o PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode debe ser PAY_PER_REQUEST o PROVISIONED"
  }
}

variable "hash_key" {
  description = "Partition key"
  type        = string
}

variable "range_key" {
  description = "Sort key"
  type        = string
  default     = null
}

variable "attributes" {
  description = "Lista de atributos"
  type = list(object({
    name = string
    type = string
  }))
}

variable "read_capacity" {
  description = "Read capacity units"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Write capacity units"
  type        = number
  default     = null
}

variable "enable_autoscaling" {
  description = "Habilitar auto scaling"
  type        = bool
  default     = false
}

variable "autoscaling_read_max_capacity" {
  description = "Máxima capacidad de lectura para autoscaling"
  type        = number
  default     = 100
}

variable "autoscaling_write_max_capacity" {
  description = "Máxima capacidad de escritura para autoscaling"
  type        = number
  default     = 100
}

variable "ttl_enabled" {
  description = "Habilitar TTL"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Nombre del atributo TTL"
  type        = string
  default     = "expiresAt"
}

variable "stream_enabled" {
  description = "Habilitar DynamoDB Streams"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Tipo de vista del stream"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "enable_point_in_time_recovery" {
  description = "Habilitar Point-in-Time Recovery"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN de la KMS key"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionales"
  type        = map(string)
  default     = {}
}