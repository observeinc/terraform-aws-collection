resource "aws_iam_role" "firehose" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role_policy.json

  dynamic "inline_policy" {
    for_each = {
      for k, v in {
        logging  = data.aws_iam_policy_document.firehose_logging.json
        s3writer = data.aws_iam_policy_document.firehose_s3writer.json
      } : k => v
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
  }
}

data "aws_iam_policy_document" "firehose_logging" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_group.firehose.arn]
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

resource "aws_iam_role" "destination" {
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.destination_assume_role_policy.json

  inline_policy {
    name   = "firehose"
    policy = data.aws_iam_policy_document.destination_firehose.json
  }
}

data "aws_iam_policy_document" "destination_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "destination_firehose" {
  statement {
    effect = "Allow"
    actions = [
      "firehose:DescribeDeliveryStream",
      "firehose:ListDeliveryStreams",
      "firehose:ListTagsForDeliveryStream",
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [aws_kinesis_firehose_delivery_stream.delivery_stream.arn]
  }
}
