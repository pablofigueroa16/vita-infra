
resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets

  name        = "${var.project_name}/${var.environment}/${each.key}"
  description = each.value.description

  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}/${var.environment}/${each.key}"
      Environment = var.environment
    }
  )
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each = var.secrets

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.secret_string

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_rotation" "secrets" {
  for_each = {
    for k, v in var.secrets : k => v
    if lookup(v, "rotation_enabled", false) == true
  }

  secret_id           = aws_secretsmanager_secret.secrets[each.key].id
  rotation_lambda_arn = lookup(each.value, "rotation_lambda_arn", null)

  rotation_rules {
    automatically_after_days = lookup(each.value, "rotation_days", 30)
  }
}