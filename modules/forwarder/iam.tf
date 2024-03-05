resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  dynamic "inline_policy" {
    for_each = {
      for k, v in {
        logging = data.aws_iam_policy_document.logging.json
        writer  = data.aws_iam_policy_document.writer.json
        queue   = data.aws_iam_policy_document.queue.json
        reader  = length(var.source_bucket_names) > 0 ? data.aws_iam_policy_document.reader.json : null
        kms     = length(var.source_kms_key_arns) > 0 ? data.aws_iam_policy_document.kms.json : null
      } : k => v if v != null
    }

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
      values   = [var.destination.arn]
    }
  }
}

data "aws_iam_policy_document" "reader" {
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [for name in var.source_bucket_names : "arn:aws:s3:::${name}"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
    ]
    resources = [for name in var.source_bucket_names : "arn:aws:s3:::${name}/*"]
  }
}

data "aws_iam_policy_document" "queue" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    resources = [aws_sqs_queue.this.arn]
  }
}

data "aws_iam_policy_document" "kms" {
  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = var.source_kms_key_arns
  }
}
