#Create an IAM Policy
resource "aws_iam_policy" "cloudwatch_access_policy" {
  name        = "${var.project_name}-${var.environment}-cloudwatch-policy"
  description = "Provides permission to access Cloudwatch"
  tags = {
    Name = "${var.project_name}-${var.environment}-cloudwatch-policy"
  }
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}
