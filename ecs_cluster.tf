resource "aws_service_discovery_private_dns_namespace" "wazuh_indexer_namespace" {
  name        = "indexer.local"
  description = "this is the local indexer dns namespace"
  vpc         = aws_vpc.vpc.id
}

resource "aws_service_discovery_private_dns_namespace" "wazuh_manager_namespace" {
  name        = "manager.local"
  description = "this is the local manager dns namespace"
  vpc         = aws_vpc.vpc.id
}

# create cloudwatch log group
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${var.project_name}-${var.environment}-td"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_cluster" "wazuh_cluster" {
  name = "${var.project_name}-${var.environment}-wazuh-cluster"
  #namespace = aws_service_discovery_private_dns_namespace.wazuhstack_namespace.arn

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

    configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.log_group.name
      }
    }
  }

  tags = {
    name = "${var.project_name}-${var.environment}-wazuh-cluster"
  }
}
