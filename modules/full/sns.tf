resource "aws_sns_topic" "this" {
  name_prefix = "${var.name}-"
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"
  statement {
    sid    = "Config"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions = [
      "SNS:Subscribe",
      "SNS:Receive",
      "SNS:ListSubscriptionsByTopic",
    ]
    resources = [
      aws_sns_topic.this.arn,
    ]
  }

  statement {
    sid    = "S3"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = [
      "SNS:Publish",
    ]
    resources = [
      aws_sns_topic.this.arn,
    ]
  }
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = module.forwarder.queue_arn
}
