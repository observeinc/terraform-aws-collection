resource "aws_iam_role" "this" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  dynamic "inline_policy" {
    for_each = {
      logging      = data.aws_iam_policy_document.logging.json
      subscription = data.aws_iam_policy_document.subscription.json
      sqs          = data.aws_iam_policy_document.sqs.json
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

data "aws_iam_policy_document" "subscription" {
  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeSubscriptionFilters",
      "logs:DeleteSubscriptionFilter",
      "logs:PutSubscriptionFilter",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "sqs" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    resources = [aws_sqs_queue.this.arn]
  }
}

resource "aws_iam_role" "scheduler" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role_policy.json

  dynamic "inline_policy" {
    for_each = {
      scheduler_sqs = data.aws_iam_policy_document.scheduler_sqs.json
    }
    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
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

data "aws_iam_policy_document" "scheduler_sqs" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]

    resources = [
      aws_sqs_queue.this.arn,
    ]
  }
}

