# VPC Outputs
output "vpc_id" {
  description = "ID de la VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs de las subredes privadas"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "IDs de las subredes públicas"
  value       = module.vpc.public_subnet_ids
}

# Cognito Outputs
output "cognito_user_pool_id" {
  description = "ID del User Pool de Cognito"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_arn" {
  description = "ARN del User Pool de Cognito"
  value       = module.cognito.user_pool_arn
}

output "cognito_client_id" {
  description = "ID del App Client de Cognito"
  value       = module.cognito.client_id
  sensitive   = true
}

output "cognito_domain" {
  description = "Dominio de Cognito"
  value       = module.cognito.domain
}

# RDS Outputs
output "rds_cluster_endpoint" {
  description = "Endpoint del cluster RDS"
  value       = module.rds.cluster_endpoint
  sensitive   = true
}

output "rds_reader_endpoint" {
  description = "Endpoint de lectura del cluster RDS"
  value       = module.rds.reader_endpoint
  sensitive   = true
}

output "rds_cluster_id" {
  description = "ID del cluster RDS"
  value       = module.rds.cluster_id
}

# DynamoDB Outputs
output "dynamodb_chat_sessions_table_name" {
  description = "Nombre de la tabla de sesiones de chat"
  value       = module.dynamodb_chat_sessions.table_name
}

output "dynamodb_chat_messages_table_name" {
  description = "Nombre de la tabla de mensajes de chat"
  value       = module.dynamodb_chat_messages.table_name
}

output "dynamodb_analytics_events_table_name" {
  description = "Nombre de la tabla de eventos de analytics"
  value       = module.dynamodb_analytics_events.table_name
}

# Redis Outputs
output "redis_endpoint" {
  description = "Endpoint de Redis"
  value       = module.redis.endpoint
  sensitive   = true
}

output "redis_port" {
  description = "Puerto de Redis"
  value       = module.redis.port
}

# S3 Outputs
output "s3_products_media_bucket" {
  description = "Nombre del bucket de productos"
  value       = module.s3_products_media.bucket_id
}

output "s3_documents_bucket" {
  description = "Nombre del bucket de documentos"
  value       = module.s3_documents.bucket_id
}

output "s3_backups_bucket" {
  description = "Nombre del bucket de backups"
  value       = module.s3_backups.bucket_id
}

# Secrets Outputs
output "secrets_arns" {
  description = "ARNs de los secretos creados"
  value       = module.secrets.secret_arns
  sensitive   = true
}

# KMS Outputs
output "kms_key_id" {
  description = "ID de la KMS key"
  value       = aws_kms_key.vita_key.id
}

output "kms_key_arn" {
  description = "ARN de la KMS key"
  value       = aws_kms_key.vita_key.arn
}