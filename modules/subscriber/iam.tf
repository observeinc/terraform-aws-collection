resource "aws_iam_role" "subscriber" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "logging" {
  name   = "logging"
  role   = aws_iam_role.subscriber.name
  policy = data.aws_iam_policy_document.logging_policy.json
}

resource "aws_iam_role_policy" "pass" {
  name   = "pass"
  role   = aws_iam_role.subscriber.name
  policy = data.aws_iam_policy_document.pass_policy.json
}

resource "aws_iam_role_policy" "queue" {
  name   = "queue"
  role   = aws_iam_role.subscriber.name
  policy = data.aws_iam_policy_document.queue_policy.json
}

resource "aws_iam_role_policy" "subscription" {
  name   = "subscription"
  role   = aws_iam_role.subscriber.name
  policy = data.aws_iam_policy_document.subscription_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [aws_cloudwatch_log_group.log_group.arn]
  }
}

data "aws_iam_policy_document" "pass_policy" {
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [var.destination_iam_arn]
  }
}

data "aws_iam_policy_document" "queue_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.queue.arn]
  }
}

data "aws_iam_policy_document" "subscription_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeSubscriptionFilters",
      "logs:DeleteSubscriptionFilter",
      "logs:PutSubscriptionFilter",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "scheduler" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role_policy.json
}

resource "aws_iam_role_policy" "scheduler_queue" {
  name   = "queue"
  role   = aws_iam_role.scheduler.name
  policy = data.aws_iam_policy_document.scheduler_queue.json
}

data "aws_iam_policy_document" "scheduler_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "scheduler_queue" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [aws_sqs_queue.queue.arn]
  }
}
