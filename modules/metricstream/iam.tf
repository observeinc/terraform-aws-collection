resource "aws_iam_role" "firehose" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role_policy.json

  dynamic "inline_policy" {
    for_each = {
      for k, v in merge({
        logging  = data.aws_iam_policy_document.firehose_logging.json
        s3writer = data.aws_iam_policy_document.firehose_s3writer.json
        }, var.enable_tag_enrichment ? {
        lambda_transform = data.aws_iam_policy_document.firehose_lambda_transform[0].json
      } : {}) : k => v
    }

    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

data "aws_iam_policy_document" "firehose_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "firehose_logging" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_group.firehose_log_group.arn]
  }
}

data "aws_iam_policy_document" "firehose_s3writer" {
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/${var.prefix}*"
    ]
  }
}

data "aws_iam_policy_document" "firehose_lambda_transform" {
  count = var.enable_tag_enrichment ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration"
    ]
    resources = ["${aws_lambda_function.metrictag[0].arn}*"]
  }
}

resource "aws_iam_role" "metric_stream" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.metric_stream_assume_role_policy.json

  inline_policy {
    name   = "firehose"
    policy = data.aws_iam_policy_document.metric_stream_firehose.json
  }
}

data "aws_iam_policy_document" "metric_stream_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "metric_stream_firehose" {
  statement {
    effect = "Allow"
    actions = [
      "firehose:DescribeDeliveryStream",
      "firehose:ListDeliveryStreams",
      "firehose:ListTagsForDeliveryStream",
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [aws_kinesis_firehose_delivery_stream.this.arn]
  }
}
