output "cluster_id" {
  description = "ID del cluster"
  value       = aws_rds_cluster.main.id
}

output "cluster_arn" {
  description = "ARN del cluster"
  value       = aws_rds_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint de escritura del cluster"
  value       = aws_rds_cluster.main.endpoint
}

output "reader_endpoint" {
  description = "Endpoint de lectura del cluster"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "database_name" {
  description = "Nombre de la base de datos"
  value       = aws_rds_cluster.main.database_name
}

output "port" {
  description = "Puerto de la base de datos"
  value       = aws_rds_cluster.main.port
}