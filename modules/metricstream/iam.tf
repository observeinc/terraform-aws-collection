resource "aws_iam_role" "firehose" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role_policy.json
}

locals {
  firehose_policies = {
    logging  = data.aws_iam_policy_document.firehose_logging.json
    s3writer = data.aws_iam_policy_document.firehose_s3writer.json
  }
}

resource "aws_iam_role_policy" "firehose" {
  for_each = local.firehose_policies

  name   = each.key
  role   = aws_iam_role.firehose.name
  policy = each.value
}

data "aws_iam_policy_document" "firehose_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
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

resource "aws_iam_role" "metric_stream" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.metric_stream_assume_role_policy.json
}

resource "aws_iam_role_policy" "metric_stream_firehose" {
  name   = "firehose"
  role   = aws_iam_role.metric_stream.name
  policy = data.aws_iam_policy_document.metric_stream_firehose.json
}

data "aws_iam_policy_document" "metric_stream_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
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
