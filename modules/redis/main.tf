resource "aws_elasticache_subnet_group" "main" {
  name        = "${var.project_name}-redis-subnet-${var.environment}"
  subnet_ids  = var.subnet_ids
  description = "Subnet group para Redis ${var.project_name} ${var.environment}"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-redis-subnet-${var.environment}"
    }
  )
}

resource "aws_elasticache_parameter_group" "main" {
  name        = "${var.project_name}-redis-params-${var.environment}"
  family      = var.parameter_group_family
  description = "Parameter group para Redis ${var.project_name} ${var.environment}"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  parameter {
    name  = "timeout"
    value = "300"
  }

  tags = var.tags
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.project_name}-redis-${var.environment}"
  description          = "Redis cluster para ${var.project_name} ${var.environment}"
  
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_nodes
  port                 = var.port
  parameter_group_name = aws_elasticache_parameter_group.main.name
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = var.security_group_ids

  automatic_failover_enabled = var.num_cache_nodes > 1 ? true : false
  multi_az_enabled           = var.num_cache_nodes > 1 ? true : false

  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  
  maintenance_window = var.maintenance_window
  
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled

  auto_minor_version_upgrade = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-redis-${var.environment}"
    }
  )

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }
}