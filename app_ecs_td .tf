# Define the ECS task and service for wazuh.dashboard
resource "aws_ecs_task_definition" "wazuh_dashboard_task" {
  count                    = 2
  family                   = "wazuh-dashboard-${count.index}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = 512
  memory                   = 512

  container_definitions = jsonencode([
    {
      "name" : "wazuh-dashboard-${count.index}",
      "image" : "wazuh/wazuh-dashboard:4.4.4",
      "essential" : true,
      "cpu": 512,
      "memory": 512,
      "portMappings" : [
        {
          "containerPort" : 5601,
          "hostPort" : 5601,
          "protocol" : "tcp"
        },
        {
          "hostPort": 443,
          "containerPort": 443
        }
      ],
      "environment" : [
        {
          "name" : "INDEXER_USERNAME",
          "value" : "admin"
        },
        {
          "name" : "INDEXER_PASSWORD",
          "value" : "SecretPassword"
        },
        {
          "name" : "WAZUH_API_URL",
          "value" : "https://wazuh.manager"
        },
        {
          "name" : "DASHBOARD_USERNAME",
          "value" : "kibanaserver"
        },
        {
          "name" : "DASHBOARD_PASSWORD",
          "value" : "kibanaserver"
        },
        {
          "name" : "API_USERNAME",
          "value" : "wazuh-wui"
        },
        {
          "name" : "API_PASSWORD",
          "value" : "MyS3cr37P450r.*-"
        }
      ],
      "mountPoints" : [
        {
          "sourceVolume": "wazuh_dashboard_config",
          "containerPath": "/usr/share/wazuh-dashboard/config",
          "readOnly": false
        },
        {
          "sourceVolume": "wazuh_dashboard_data",
          "containerPath": "/usr/share/wazuh-dashboard/data/wazuh/config/",
          "readOnly": false
        },
        {
          "sourceVolume": "wazuh_dashboard_certs",
          "containerPath": "/usr/share/wazuh-dashboard/certs",
          "readOnly": false
        }
        
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = "${aws_cloudwatch_log_group.log_group.name}",
          "awslogs-region"        = "${var.region}",
          "awslogs-stream-prefix" = "wazuh-indexer-${count.index}"
        }
      }
    }
  ])

  # volume {
  #   name      = "wazuh_dashboard_config"
  #   host_path = "/${var.customerID}/${var.dashboardID}${count.index}/opensearch-d"
  # }

  # volume {
  #   name      = "wazuh_dashboard_data"
  #   host_path = "/${var.customerID}/${var.dashboardID}${count.index}/data"
  # }

  #  volume {
  #   name      = "wazuh_dashboard_certs"
  #   host_path = "/${var.customerID}/${var.dashboardID}${count.index}/certs"
  # }

    # # Define the necessary volumes for the ECS services
  # volume {
  #   name      = "wazuh_dashboard_config"
  #   efs_volume_configuration {
  #     file_system_id = "fs-XXXXXXXX"
  #     transit_encryption = "ENABLED"
  #     root_directory = "/${var.customerID}/${var.dashboardID}${count.index}/config"
  #   }
  # }

  # volume {
  #   name      = "wazuh_dashboard_data"
  #   efs_volume_configuration {
  #     file_system_id = "fs-XXXXXXXX"
  #     transit_encryption = "ENABLED"
  #     root_directory = "/${var.customerID}/${var.dashboardID}${count.index}/data"
  #   }
  # }

  # volume {
  #   name      = "wazuh_dashboard_certs"
  #   efs_volume_configuration {
  #     file_system_id = "fs-XXXXXXXX"
  #     transit_encryption = "ENABLED"
  #     root_directory = "/${var.customerID}/${var.dashboardID}${count.index}/certs"
  #   }
  # }

}

resource "aws_ecs_service" "wazuh_dashboard_service" {
  count = 1
  name            = "wazuh-dashboard-service-${count.index}"
  cluster         = aws_ecs_cluster.wazuh_cluster.id
  task_definition = aws_ecs_task_definition.wazuh_dashboard_task[count.index].arn
  launch_type     = "EC2"
  desired_count   = 2
  network_configuration {
    subnets          = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az1.id]
    security_groups  = [aws_security_group.wazuh_security_group.id]
    assign_public_ip = false
  }
}
