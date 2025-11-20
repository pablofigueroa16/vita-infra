variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment to deploy resources (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }

}

variable "project_name" {
  description = "vita"
  type        = string
  default     = "vita"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to deploy resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "db_username" {
  description = "DB Admin Username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "DB Admin Password"
  type        = string
  sensitive   = true
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_point_in_time_recovery" {
  description = "Enable Point in Time Recovery for DB"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to deploy resources"
  type        = map(string)
  default     = {}
}