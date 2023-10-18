# create cloudwatch log group
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${var.project_name}-task-definition"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_cluster" "wazuh_cluster" {
  name = "${var.project_name}-cluster"
  #namespace = aws_service_discovery_private_dns_namespace.wazuhstack_namespace.arn

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.log_group.name
      }
    }
  }

  tags = {
    name = "${var.project_name}-cluster"
  }
}
