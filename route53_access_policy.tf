resource "aws_iam_policy" "route53_access_policy" {
  name        = "${var.project_name}-route53-policy"
  description = "Provides permission to access route53"
  tags = {
    Name = "${var.project_name}-route53-policy"
  }
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53domains:*",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ]
      }
    ]
  })
}
