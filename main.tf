
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  enable_nat_gateway = var.enable_nat_gateway

  tags = var.tags
}

module "cognito" {
  source = "./modules/cognito"

  project_name = var.project_name
  environment  = var.environment

  password_minimum_length    = 8
  password_require_lowercase = true
  password_require_uppercase = true
  password_require_numbers   = true
  password_require_symbols   = true

  mfa_configuration = "OPTIONAL"

  email_verification_message = "Tu código de verificación es: {####}"
  email_verification_subject = "Verifica tu cuenta en VITA"

  tags = var.tags
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.database_security_group_id]

  database_name   = "vita_${var.environment}"
  master_username = var.db_username
  master_password = var.db_password

  engine_version = "15.4"
  instance_class = "db.serverless"

  serverless_min_capacity = var.environment == "prod" ? 14 : 7
  serverless_max_capacity = var.environment == "prod" ? 16.0 : 4.0

  backup_retention_period      = var.environment == "prod" ? 14 : 7
  preferred_backup_window      = "03:00-04:00"
  preferred_maintenance_window = "mon:04:00-mon:05:00"

  storage_encrypted = true

  tags = var.tags
}

module "dynamodb_chat_sessions" {
  source = "./modules/dynamodb"

  table_name   = "${var.project_name}-chat-sessions-${var.environment}"
  billing_mode = var.environment == "prod" ? "PROVISIONED" : "PAY_PER_REQUEST"

  hash_key  = "userId"
  range_key = "sessionId"

  attributes = [
    {
      name = "userId"
      type = "S"
    },
    {
      name = "sessionId"
      type = "S"
    }
  ]

  read_capacity  = var.environment == "prod" ? 5 : null
  write_capacity = var.environment == "prod" ? 5 : null

  enable_autoscaling = var.environment == "prod"

  enable_point_in_time_recovery = var.enable_point_in_time_recovery

  ttl_enabled        = true
  ttl_attribute_name = "expiresAt"

  tags = var.tags
}

module "dynamodb_chat_messages" {
  source = "./modules/dynamodb"

  table_name   = "${var.project_name}-chat-messages-${var.environment}"
  billing_mode = var.environment == "prod" ? "PROVISIONED" : "PAY_PER_REQUEST"

  hash_key  = "sessionId"
  range_key = "timestamp"

  attributes = [
    {
      name = "sessionId"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    }
  ]

  read_capacity  = var.environment == "prod" ? 10 : null
  write_capacity = var.environment == "prod" ? 10 : null

  enable_autoscaling            = var.environment == "prod"
  enable_point_in_time_recovery = var.enable_point_in_time_recovery

  tags = var.tags
}

module "dynamodb_analytics_events" {
  source = "./modules/dynamodb"

  table_name   = "${var.project_name}-analytics-events-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "tenantId"
  range_key = "timestamp"

  attributes = [
    {
      name = "tenantId"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    }
  ]

  enable_point_in_time_recovery = var.enable_point_in_time_recovery

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = var.tags
}

resource "random_password" "redis_auth_token" {
  length  = 32
  special = false
}

module "redis" {
  source = "./modules/redis"

  project_name = var.project_name
  environment  = var.environment
  
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.cache_security_group_id]
  
  node_type               = var.environment == "prod" ? "cache.r7g.large" : "cache.t4g.micro"
  num_cache_nodes         = var.environment == "prod" ? 3 : 1
  engine_version          = "7.1"
  parameter_group_family  = "redis7"
  port                    = 6379
  
  snapshot_retention_limit = var.environment == "prod" ? 7 : 1
  snapshot_window          = "03:00-05:00"
  maintenance_window       = "sun:05:00-sun:07:00"
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false
  
  tags = var.tags
}

module "s3_products_media" {
  source = "./modules/s3"

  bucket_name = "${var.project_name}-products-media-${var.environment}"
  environment = var.environment

  versioning_enabled = var.environment == "prod"

  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "PUT", "POST"]
      allowed_origins = var.environment == "prod" ? ["https://vita.com", "https://app.vita.com"] : ["*"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]

  lifecycle_rules = [
    {
      id      = "delete-old-versions"
      enabled = true
      noncurrent_version_expiration = {
        days = 90
      }
    }
  ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

module "s3_documents" {
  source = "./modules/s3"

  bucket_name = "${var.project_name}-documents-${var.environment}"
  environment = var.environment

  versioning_enabled = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.vita_key.id
      }
    }
  }

  tags = var.tags
}

module "s3_backups" {
  source = "./modules/s3"

  bucket_name = "${var.project_name}-backups-${var.environment}"
  environment = var.environment

  versioning_enabled = true

  lifecycle_rules = [
    {
      id      = "archive-old-backups"
      enabled = true
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
      expiration = {
        days = 365
      }
    }
  ]

  tags = var.tags
}

module "secrets" {
  source = "./modules/secrets"

  project_name = var.project_name
  environment  = var.environment

  secrets = {
    database_url = {
      description = "URL de conexión a la base de datos"
      secret_string = jsonencode({
        username = var.db_username
        password = var.db_password
        host     = module.rds.cluster_endpoint
        port     = 5432
        database = "vita_${var.environment}"
        url      = "postgresql://${var.db_username}:${var.db_password}@${module.rds.cluster_endpoint}:5432/vita_${var.environment}"
      })
    }

    jwt_secret = {
      description   = "Secret para firma de JWT tokens"
      secret_string = random_password.jwt_secret.result
    }

    encryption_key = {
      description   = "Clave de encriptación para datos sensibles"
      secret_string = random_password.encryption_key.result
    }

    redis_url = {
      description = "URL de conexión a Redis"
      secret_string = jsonencode({
        host = module.redis.endpoint
        port = module.redis.port
        url  = "redis://${module.redis.endpoint}:${module.redis.port}"
      })
    }
  }

  tags = var.tags
}

resource "aws_kms_key" "vita_key" {
  description             = "KMS key para encriptación de datos VITA"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-kms-${var.environment}"
    }
  )
}

resource "aws_kms_alias" "vita_key_alias" {
  name          = "alias/${var.project_name}-${var.environment}"
  target_key_id = aws_kms_key.vita_key.key_id
}

resource "random_password" "jwt_secret" {
  length  = 64
  special = true
}

resource "random_password" "encryption_key" {
  length  = 32
  special = false
}