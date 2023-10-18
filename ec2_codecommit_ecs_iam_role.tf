#Create an IAM role
resource "aws_iam_role" "EC2_CodeCommit_and_ECS" {
  name = "${var.project_name}-${var.environment}-ec2-codecommit-ecs-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.project_name}-${var.environment}-ec2-codecommit-ecs-role"
  }
}

#Attach role to policy
resource "aws_iam_policy_attachment" "codecommit-role-attachment" {
  name       = "${var.project_name}-${var.environment}-role-attachment"
  roles      = [aws_iam_role.EC2_CodeCommit_and_ECS.name]
  policy_arn = aws_iam_policy.codecommit_access_policy.arn
}

#Attach role to policy
resource "aws_iam_policy_attachment" "ecs-role-attachment" {
  name       = "${var.project_name}-${var.environment}-role-attachment"
  roles      = [aws_iam_role.EC2_CodeCommit_and_ECS.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

#Attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.EC2_CodeCommit_and_ECS.name
}