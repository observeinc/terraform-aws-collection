locals {
  sns_enabled = contains(var.sources, "sns")
}

resource "aws_s3_bucket" "source" {
  for_each      = var.sources
  bucket        = "${var.run_id}-${each.key}"
  force_destroy = true
}

resource "aws_sns_topic" "this" {
  count = local.sns_enabled ? 1 : 0
  name  = var.run_id
}

data "aws_iam_policy_document" "s3_to_sns" {
  count = local.sns_enabled ? 1 : 0
  statement {
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.this[0].arn]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_sns_topic_policy" "s3_to_sns" {
  count  = local.sns_enabled ? 1 : 0
  arn    = aws_sns_topic.this[0].arn
  policy = data.aws_iam_policy_document.s3_to_sns[0].json
}

resource "aws_sns_topic_subscription" "this" {
  count     = local.sns_enabled ? 1 : 0
  protocol  = "sqs"
  topic_arn = aws_sns_topic.this[0].arn
  endpoint  = var.queue_arn
}

resource "aws_s3_bucket_notification" "this" {
  for_each = var.sources

  bucket = aws_s3_bucket.source[each.key].bucket

  dynamic "queue" {
    for_each = each.key == "sqs" ? [1] : []
    content {
      queue_arn = var.queue_arn
      events    = ["s3:ObjectCreated:*"]
    }
  }

  dynamic "topic" {
    for_each = each.key == "sns" ? [1] : []
    content {
      topic_arn = aws_sns_topic.this[0].arn
      events    = ["s3:ObjectCreated:*"]
    }
  }

  eventbridge = each.key == "eventbridge"

  depends_on = [aws_sns_topic_policy.s3_to_sns]
}

resource "time_sleep" "wait" {
  count           = var.sleep_interval != "" ? 1 : 0
  create_duration = var.sleep_interval
  depends_on      = [aws_s3_bucket_notification.this, ]
}
