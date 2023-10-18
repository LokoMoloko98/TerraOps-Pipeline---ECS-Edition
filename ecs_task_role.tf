#Create an ecs task role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow"
        Sid = ""
      },
    ]
  })

  tags = {
    tag-key = "${var.project_name}-${var.environment}-ecs-task-execution-role"
  }
}


# attach ecs task execution role to codecommit access policy
resource "aws_iam_role_policy_attachment" "ecs_codecommit_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.codecommit_access_policy_for_ecs.arn
}

# attach ecs task execution role to cloudwatch access policy
resource "aws_iam_role_policy_attachment" "ecs_cloudwatch_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.cloudwatch_access_policy.arn
}