locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  sqs_arn    = "arn:${data.aws_partition.current.id}:sqs:${local.region}:${local.account_id}:${var.name}"
  enable_dlq = var.queue_max_receive_count > 0
}

resource "aws_sqs_queue" "this" {
  name = var.name
  # tie this to lambda execution time since both are tightly coupled
  visibility_timeout_seconds = var.lambda_timeout != null ? var.lambda_timeout : local.default_limits.timeout
  delay_seconds              = var.queue_delay_seconds
  message_retention_seconds  = var.queue_message_retention_seconds

  redrive_policy = local.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.queue_max_receive_count
  }) : null

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = local.sqs_arn
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = [for name in var.source_bucket_names : "arn:${data.aws_partition.current.id}:s3:::${name}"]
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = local.sqs_arn
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.source_topic_arns
          }
        }
      },
      {
        Effect   = "Allow",
        Action   = "sqs:SendMessage",
        Resource = local.sqs_arn,
        Principal = {
          "Service" : "events.amazonaws.com"
        },
      },
    ]
  })
}

resource "aws_sqs_queue" "dlq" {
  count                     = local.enable_dlq ? 1 : 0
  name                      = "${var.name}-dlq"
  message_retention_seconds = var.queue_message_retention_seconds
}

resource "aws_sqs_queue_redrive_allow_policy" "dlq" {
  count     = local.enable_dlq ? 1 : 0
  queue_url = aws_sqs_queue.dlq[0].id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.this.arn]
  })
}
