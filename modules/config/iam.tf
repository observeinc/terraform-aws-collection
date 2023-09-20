resource "aws_iam_role" "this" {
  name_prefix        = "${var.name}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  managed_policy_arns = [
    data.aws_iam_policy.service_role.arn
  ]

  inline_policy {
    name   = "writer"
    policy = data.aws_iam_policy_document.writer.json
  }

  dynamic "inline_policy" {
    for_each = var.sns_topic_arn != null ? [1] : []
    content {
      name   = "notifications"
      policy = data.aws_iam_policy_document.notifications.json
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "writer" {
  statement {
    actions = [
      "s3:GetBucketAcl",
      "s3:ListObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket}/${var.prefix}AWSLogs/*",
    ]
  }
}

data "aws_iam_policy_document" "notifications" {
  statement {
    actions = [
      "sns:Publish",
    ]

    resources = [
      var.sns_topic_arn != null ? var.sns_topic_arn : "",
    ]
  }
}

data "aws_iam_policy" "service_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}
