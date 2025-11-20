variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subredes para Redis"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs de los security groups"
  type        = list(string)
}

variable "node_type" {
  description = "Tipo de nodo de ElastiCache"
  type        = string
  default     = "cache.t4g.micro"
}

variable "num_cache_nodes" {
  description = "Número de nodos de cache"
  type        = number
  default     = 1
}

variable "engine_version" {
  description = "Versión del engine Redis"
  type        = string
  default     = "7.1"
}

variable "parameter_group_family" {
  description = "Familia del parameter group"
  type        = string
  default     = "redis7"
}

variable "port" {
  description = "Puerto de Redis"
  type        = number
  default     = 6379
}

variable "snapshot_retention_limit" {
  description = "Días de retención de snapshots"
  type        = number
  default     = 1
}

variable "snapshot_window" {
  description = "Ventana de snapshots"
  type        = string
  default     = "03:00-05:00"
}

variable "maintenance_window" {
  description = "Ventana de mantenimiento"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "at_rest_encryption_enabled" {
  description = "Habilitar encriptación en reposo"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Habilitar encriptación en tránsito"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionales"
  type        = map(string)
  default     = {}
}