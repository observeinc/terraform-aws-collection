resource "aws_sqs_queue" "dead_letter" {
  name = "${var.name}-deadletter"

  tags = merge(var.tags, var.dead_letter_queue_tags)
}

resource "aws_sqs_queue" "queue" {
  name                      = var.name
  delay_seconds             = 0
  message_retention_seconds = 1209600
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter.arn
    maxReceiveCount     = 4
  })
  visibility_timeout_seconds = var.lambda_timeout

  tags = var.tags
}

resource "aws_sqs_queue_policy" "queue_policy" {
  policy    = data.aws_iam_policy_document.queue.json
  queue_url = aws_sqs_queue.queue.id
}

data "aws_iam_policy_document" "queue" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.queue.arn]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  dynamic "statement" {
    for_each = local.enable_provisioners ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "sqs:SendMessage",
        "sqs:GetQueueAttributes",
      ]
      resources = [aws_sqs_queue.queue.arn]
      principals {
        type        = "AWS"
        identifiers = [data.aws_caller_identity.current.arn]
      }
    }
  }
}

resource "aws_sqs_queue_policy" "dead_letter_policy" {
  count     = local.enable_provisioners ? 1 : 0
  policy    = data.aws_iam_policy_document.dead_letter_queue[0].json
  queue_url = aws_sqs_queue.dead_letter.id
}

data "aws_iam_policy_document" "dead_letter_queue" {
  count = local.enable_provisioners ? 1 : 0
  statement {
    effect    = "Allow"
    actions   = ["sqs:GetQueueAttributes"]
    resources = [aws_sqs_queue.dead_letter.arn]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }
  }
}
