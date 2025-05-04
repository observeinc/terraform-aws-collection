data "aws_partition" "current" {}

resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:${data.aws_partition.current.id}:iam::${var.observe_aws_account_id}:root"
          ]
        },
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.datastream_ids
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "allowed" {
  name = "allowed"
  role = aws_iam_role.this.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = var.allowed_actions,
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}