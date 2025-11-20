# User Pool
resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-users-${var.environment}"

  # Configuración de políticas de contraseña
  password_policy {
    minimum_length                   = var.password_minimum_length
    require_lowercase                = var.password_require_lowercase
    require_uppercase                = var.password_require_uppercase
    require_numbers                  = var.password_require_numbers
    require_symbols                  = var.password_require_symbols
    temporary_password_validity_days = 7
  }

  # MFA
  mfa_configuration = var.mfa_configuration

  # Atributos requeridos
  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    name                = "given_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    name                = "family_name"
    attribute_data_type = "String"
    mutable             = true
    required            = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  # Auto-verificación por email
  auto_verified_attributes = ["email"]

  # Configuración de email
  email_verification_message = var.email_verification_message
  email_verification_subject = var.email_verification_subject

  # Configuración de recuperación de cuenta
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  # Prevención de enumeración de usuarios
  user_pool_add_ons {
    advanced_security_mode = "ENFORCED"
  }

  # Configuración de dispositivos
  device_configuration {
    challenge_required_on_new_device      = false
    device_only_remembered_on_user_prompt = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-user-pool-${var.environment}"
    }
  )
}

# App Client
resource "aws_cognito_user_pool_client" "web" {
  name         = "${var.project_name}-web-client-${var.environment}"
  user_pool_id = aws_cognito_user_pool.main.id

  # Flujos de autenticación
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  # Configuración de tokens
  access_token_validity  = 1  # 1 hora
  id_token_validity      = 1  # 1 hora
  refresh_token_validity = 30 # 30 días

  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }

  # Prevenir secret de cliente (para SPAs)
  generate_secret = false

  # Scopes permitidos
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  # Callbacks (ajustar según tu dominio)
  callback_urls = var.environment == "prod" ? [
    "https://vita.com/auth/callback",
    "https://app.vita.com/auth/callback"
    ] : [
    "http://localhost:3000/auth/callback"
  ]

  logout_urls = var.environment == "prod" ? [
    "https://vita.com",
    "https://app.vita.com"
    ] : [
    "http://localhost:3000"
  ]

  # Lectura y escritura de atributos
  read_attributes = [
    "email",
    "email_verified",
    "given_name",
    "family_name"
  ]

  write_attributes = [
    "email",
    "given_name",
    "family_name"
  ]

  # Prevenir tokens inválidos
  prevent_user_existence_errors = "ENABLED"
}

# Dominio de Cognito
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.project_name}-auth-${var.environment}"
  user_pool_id = aws_cognito_user_pool.main.id
}

# Identity Provider de Google (opcional)
resource "aws_cognito_identity_provider" "google" {
  count = var.enable_google_login ? 1 : 0

  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email profile openid"
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret
  }

  attribute_mapping = {
    email       = "email"
    given_name  = "given_name"
    family_name = "family_name"
    username    = "sub"
  }
}