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
            "arn:aws:iam::${var.observe_aws_account_id}:root"
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

  inline_policy {
    name = "allowed"

    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = var.allowed_actions

          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }
}
