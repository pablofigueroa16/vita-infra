output "bucket_id" {
  description = "ID del bucket"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN del bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_domain_name" {
  description = "Domain name del bucket"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name del bucket"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "bucket_region" {
  description = "Región del bucket"
  value       = aws_s3_bucket.main.region
}