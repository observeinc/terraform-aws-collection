resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  dynamic "inline_policy" {
    for_each = local.policies
    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.this.arn}*",
    ]
  }
}

data "aws_iam_policy_document" "writer" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "s3:DataAccessPointArn"

      values = [
        var.destination.arn
      ]
    }
  }
}

data "aws_iam_policy_document" "reader" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = local.read_any ? ["*"] : var.bucket_arns
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
    ]

    resources = local.read_any ? ["*"] : var.bucket_arns
  }
}
