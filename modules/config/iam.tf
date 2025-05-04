resource "aws_iam_role" "this" {
  name_prefix        = "${var.name}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "service_role" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.service_role.arn
}

resource "aws_iam_role_policy" "writer" {
  name   = "writer"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.writer.json
}

resource "aws_iam_role_policy" "notifications" {
  count  = var.sns_topic_arn != null && var.sns_topic_arn != "" ? 1 : 0
  name   = "notifications"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.notifications.json
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
      "arn:${data.aws_partition.current.id}:s3:::${var.bucket}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:${data.aws_partition.current.id}:s3:::${var.bucket}/${var.prefix}AWSLogs/*",
    ]
  }
}

data "aws_iam_policy_document" "notifications" {
  dynamic "statement" {
    for_each = var.sns_topic_arn != null && var.sns_topic_arn != "" ? [1] : []
    content {
      actions   = ["sns:Publish"]
      resources = [var.sns_topic_arn]
    }
  }
}

data "aws_iam_policy" "service_role" {
  arn = "arn:${data.aws_partition.current.id}:iam::aws:policy/service-role/AWS_ConfigRole"
}