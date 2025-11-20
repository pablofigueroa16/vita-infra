infra/
├── terraform/
│   ├── main.tf                      # Configuración principal
│   ├── variables.tf                 # Variables globales
│   ├── outputs.tf                   # Outputs importantes
│   ├── providers.tf                 # Configuración de providers
│   ├── backend.tf                   # S3 backend para state
│   │
│   ├── modules/                     # Módulos reutilizables
│   │   ├── cognito/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── rds/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── dynamodb/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── redis/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── s3/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── vpc/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   └── secrets/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   └── environments/                # Configuración por ambiente
│       ├── dev/
│       │   ├── terraform.tfvars
│       │   └── backend.hcl
│       │
│       ├── staging/
│       │   ├── terraform.tfvars
│       │   └── backend.hcl
│       │
│       └── prod/
│           ├── terraform.tfvars
│           └── backend.hcl


[ ] CREAR POLÍTICA IAM PERSONALIZADA PARA TERRAFORM (Producción)

bootstrap.tf

terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Bucket S3 para el state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "vita-terraform-state-dev"
  
  tags = {
    Name        = "Terraform State"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Tabla DynamoDB para locks
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "vita-terraform-locks-dev"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Locks"
    Environment = "dev"
  }
}

# Outputs
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}

[] ✅ OPCIÓN 2: CREAR EL BACKEND S3 + DYNAMODB (Para producción)