variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subredes para RDS"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs de los security groups"
  type        = list(string)
}

variable "database_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "master_username" {
  description = "Usuario master"
  type        = string
  sensitive   = true
}

variable "master_password" {
  description = "Contraseña master"
  type        = string
  sensitive   = true
}

variable "engine_version" {
  description = "Versión del engine PostgreSQL"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Clase de instancia"
  type        = string
  default     = "db.serverless"
}

variable "instance_count" {
  description = "Número de instancias"
  type        = number
  default     = 1
}

variable "serverless_min_capacity" {
  description = "Capacidad mínima serverless"
  type        = number
  default     = 0.5
}

variable "serverless_max_capacity" {
  description = "Capacidad máxima serverless"
  type        = number
  default     = 16.0
}

variable "backup_retention_period" {
  description = "Días de retención de backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Ventana de backup"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Ventana de mantenimiento"
  type        = string
  default     = "mon:04:00-mon:05:00"
}

variable "storage_encrypted" {
  description = "Habilitar encriptación"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "ID de la KMS key"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionales"
  type        = map(string)
  default     = {}
}