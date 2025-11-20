output "replication_group_id" {
  description = "ID del replication group"
  value       = aws_elasticache_replication_group.main.id
}

output "replication_group_arn" {
  description = "ARN del replication group"
  value       = aws_elasticache_replication_group.main.arn
}

output "primary_endpoint" {
  description = "Endpoint primario de Redis"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "reader_endpoint" {
  description = "Endpoint de lectura de Redis"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "endpoint" {
  description = "Endpoint principal (alias de primary_endpoint)"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "port" {
  description = "Puerto de Redis"
  value       = aws_elasticache_replication_group.main.port
}

output "configuration_endpoint" {
  description = "Configuration endpoint para cluster mode"
  value       = aws_elasticache_replication_group.main.configuration_endpoint_address
}

output "member_clusters" {
  description = "Lista de cluster members"
  value       = aws_elasticache_replication_group.main.member_clusters
}