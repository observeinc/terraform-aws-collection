resource "aws_iam_role" "metrictag" {
  count              = var.enable_tag_enrichment ? 1 : 0
  name_prefix        = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.metrictag_assume_role_policy[0].json

  dynamic "inline_policy" {
    for_each = {
      logging = data.aws_iam_policy_document.metrictag_logging[0].json
      tagging = data.aws_iam_policy_document.metrictag_tagging[0].json
    }

    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

data "aws_iam_policy_document" "metrictag_assume_role_policy" {
  count = var.enable_tag_enrichment ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "metrictag_logging" {
  count = var.enable_tag_enrichment ? 1 : 0
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_group.metrictag[0].arn]
  }
}

data "aws_iam_policy_document" "metrictag_tagging" {
  count = var.enable_tag_enrichment ? 1 : 0
  # Follows YACE auth docs (yet-another-cloudwatch-exporter README
  # #authentication) minus cloudwatch:* and iam:ListAccountAliases, which are
  # not needed because this Lambda enriches Firehose records and does not
  # scrape CloudWatch.
  statement {
    effect = "Allow"
    actions = [
      "tag:GetResources",
      "autoscaling:DescribeAutoScalingGroups",
      "apigateway:GET",
      "ec2:DescribeSpotFleetRequests",
      "ec2:DescribeTransitGatewayAttachments",
      "dms:DescribeReplicationInstances",
      "dms:DescribeReplicationTasks",
      "aps:ListWorkspaces",
      "storagegateway:ListGateways",
      "storagegateway:ListTagsForResource",
      "shield:ListProtections"
    ]
    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_group" "metrictag" {
  count             = var.enable_tag_enrichment ? 1 : 0
  name              = "/aws/lambda/${local.metrictag_name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key

  tags = var.tags
}

resource "aws_lambda_function" "metrictag" {
  count         = var.enable_tag_enrichment ? 1 : 0
  function_name = local.metrictag_name
  s3_bucket     = local.metrictag_s3["bucket"]
  s3_key        = local.metrictag_s3["key"]
  role          = aws_iam_role.metrictag[0].arn
  architectures = ["arm64"]
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  timeout       = 60

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.metrictag[0].name
  }

  environment {
    variables = {
      RESOURCE_CACHE_TTL_SECONDS = tostring(var.tag_enrichment_cache_ttl_seconds)
      VERBOSITY                  = "1"
    }
  }

  tags = var.tags
}

resource "aws_lambda_permission" "metrictag_firehose" {
  count         = var.enable_tag_enrichment ? 1 : 0
  function_name = aws_lambda_function.metrictag[0].function_name
  action        = "lambda:InvokeFunction"
  principal     = "firehose.amazonaws.com"
  source_arn    = aws_kinesis_firehose_delivery_stream.this.arn
}
