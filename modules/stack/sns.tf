data "aws_caller_identity" "current" {}

locals {
  # When source_accounts is set, automatically include the current (audit) account
  # to ensure the local AWS Config can also publish to the SNS topic
  effective_source_accounts = length(var.source_accounts) > 0 ? distinct(concat(
    var.source_accounts,
    [data.aws_caller_identity.current.account_id]
  )) : []
}

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

  # Optional: if org_id is set, add an AllowAWSConfigFromOrg statement that
  # allows config.amazonaws.com to publish, restricted by aws:PrincipalOrgID.
  dynamic "statement" {
    for_each = var.org_id == null ? [] : [1]
    content {
      sid    = "AllowAWSConfigFromOrg"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["config.amazonaws.com"]
      }

      actions = [
        "SNS:Publish",
      ]

      resources = [
        aws_sns_topic.this.arn
      ]

      condition {
        test     = "StringEquals"
        variable = "aws:PrincipalOrgID"
        values   = [var.org_id]
      }
    }
  }
  # Optional: if source_accounts is non-empty, add an AllowAWSConfigFromSourceAccounts
  # statement that restricts publishes by AWS:SourceAccount.
  # This automatically includes the current (audit) account ID.
  dynamic "statement" {
    for_each = length(local.effective_source_accounts) == 0 ? [] : [1]
    content {
      sid    = "AllowAWSConfigFromSourceAccounts"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["config.amazonaws.com"]
      }

      actions = [
        "SNS:Publish",
      ]

      resources = [
        aws_sns_topic.this.arn,
      ]

      condition {
        test     = "StringEquals"
        variable = "AWS:SourceAccount"
        values   = local.effective_source_accounts
      }
    }
  }

}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = module.forwarder.queue_arn
}
