resource "aws_sqs_queue" "dead_letter" {
  name = "${var.name}-deadletter"

  tags = var.tags
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
  }
}