output "table_id" {
  description = "ID de la tabla"
  value       = aws_dynamodb_table.main.id
}

output "table_name" {
  description = "Nombre de la tabla"
  value       = aws_dynamodb_table.main.name
}

output "table_arn" {
  description = "ARN de la tabla"
  value       = aws_dynamodb_table.main.arn
}

output "stream_arn" {
  description = "ARN del stream"
  value       = try(aws_dynamodb_table.main.stream_arn, null)
}

output "stream_label" {
  description = "Label del stream"
  value       = try(aws_dynamodb_table.main.stream_label, null)
}