locals {
  should_create_reader = (
    var.source_bucket_names != null && length(var.source_bucket_names) > 0 &&
    var.source_object_keys != null && length(var.source_object_keys) > 0
  )

  reader_policy = local.should_create_reader ? (
    data.aws_iam_policy_document.reader.json
    ) : jsonencode({
      Version = "2012-10-17",
      Statement = [{ Effect = "Allow", Action = ["s3:GetObject"],
        Resource = ["arn:aws:s3:::non-existent-bucket/*"],
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:nobody"
          }
        }
        }
      ]
  })
}

resource "aws_iam_role" "this" {
  name               = var.destination.arn != "" ? var.name : null
  name_prefix        = var.destination.arn != "" ? null : local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy" "logging" {
  name   = "logging"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.logging.json
}

resource "aws_iam_role_policy" "queue" {
  name   = "queue"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.queue.json
}

resource "aws_iam_role_policy" "writer" {
  name   = "writer"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.writer.json
}

resource "aws_iam_role_policy" "reader" {
  name   = "reader"
  role   = aws_iam_role.this.id
  policy = local.reader_policy
}

resource "aws_iam_role_policy" "kms" {
  count  = length(var.source_kms_key_arns) > 0 && var.source_kms_key_arns != null ? 1 : 0
  name   = "kms"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.kms.json
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
    resources = ["${aws_cloudwatch_log_group.this.arn}*"]
  }
}

data "aws_iam_policy_document" "queue" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [aws_sqs_queue.this.arn]
  }
}

data "aws_iam_policy_document" "writer" {
  dynamic "statement" {
    for_each = var.destination.bucket != "" && var.destination.bucket != null ? [1] : []
    content {
      actions   = ["s3:PutObject", "s3:PutObjectTagging", ]
      resources = var.destination.arn != "" && var.destination.arn != null ? ["*"] : ["arn:${data.aws_partition.current.id}:s3:::${var.destination.bucket}/${var.destination.prefix}*"]
      dynamic "condition" {
        for_each = var.destination.arn != "" && var.destination.arn != null ? [1] : []
        content {
          test     = "StringLike"
          variable = "s3:DataAccessPointArn"
          values   = [var.destination.arn]
        }
      }
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::non-existent-bucket/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:nobody"]
    }
  }
}

data "aws_iam_policy_document" "reader" {
  dynamic "statement" {
    for_each = var.source_bucket_names != null && length(var.source_bucket_names) > 0 ? [1] : []
    content {
      effect    = "Allow"
      actions   = ["s3:GetObject", ]
      resources = [for bucket in var.source_bucket_names : "arn:aws:s3:::${bucket}/*" if bucket != ""]
    }
  }
}

data "aws_iam_policy_document" "kms" {
  dynamic "statement" {
    for_each = length(var.source_kms_key_arns) > 0 && var.source_kms_key_arns != null ? [1] : []
    content {
      actions   = ["kms:Decrypt"]
      resources = var.source_kms_key_arns
    }
  }
}