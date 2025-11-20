output "user_pool_id" {
  description = "ID del User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "user_pool_arn" {
  description = "ARN del User Pool"
  value       = aws_cognito_user_pool.main.arn
}

output "user_pool_endpoint" {
  description = "Endpoint del User Pool"
  value       = aws_cognito_user_pool.main.endpoint
}

output "client_id" {
  description = "ID del App Client"
  value       = aws_cognito_user_pool_client.web.id
}

output "domain" {
  description = "Dominio de Cognito"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "domain_cloudfront" {
  description = "CloudFront distribution del dominio de Cognito"
  value       = aws_cognito_user_pool_domain.main.cloudfront_distribution
}