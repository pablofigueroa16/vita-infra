output "secret_ids" {
  description = "IDs de los secretos creados"
  value = {
    for k, v in aws_secretsmanager_secret.secrets : k => v.id
  }
}

output "secret_arns" {
  description = "ARNs de los secretos creados"
  value = {
    for k, v in aws_secretsmanager_secret.secrets : k => v.arn
  }
  sensitive = true
}

output "secret_names" {
  description = "Nombres de los secretos creados"
  value = {
    for k, v in aws_secretsmanager_secret.secrets : k => v.name
  }
}