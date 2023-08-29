locals {
  create_s3_bucket = var.s3_bucket == null
  bucket_name      = local.create_s3_bucket ? "${local.name_prefix}${data.aws_region.current.name}-${random_string.this[0].id}" : var.s3_bucket.id
  bucket_arn       = "arn:aws:s3:::${local.bucket_name}"
  aws_logs_arn     = "${local.bucket_arn}/${local.s3_exported_prefix}AWSLogs/${data.aws_caller_identity.current.account_id}/*"

  s3_bucket = local.create_s3_bucket ? {
    id  = module.s3_bucket[0].s3_bucket_id
    arn = module.s3_bucket[0].s3_bucket_arn
  } : var.s3_bucket
}

resource "random_string" "this" {
  count   = local.create_s3_bucket ? 1 : 0
  length  = 8
  upper   = false
  special = false
}

moved {
  from = module.s3_bucket
  to   = module.s3_bucket[0]
}

module "s3_bucket" {
  count   = local.create_s3_bucket ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15.1"

  bucket        = local.bucket_name
  acl           = "log-delivery-write"
  force_destroy = true

  lifecycle_rule = var.s3_lifecycle_rule

  logging = var.s3_logging ? {
    target_bucket = local.bucket_name
    target_prefix = "${local.s3_exported_prefix}S3ServerLogs/"
  } : {}

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true
  attach_policy                  = true
  policy                         = data.aws_iam_policy_document.bucket.json

  tags = var.tags
}

data "aws_redshift_service_account" "this" {}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      local.aws_logs_arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      local.bucket_arn,
    ]
  }

  statement {
    sid    = "AWSConfigWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      local.aws_logs_arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AWSConfigAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      local.bucket_arn,
    ]
  }

  statement {
    sid    = "AWSRedshiftWrite"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.this.arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      local.aws_logs_arn,
    ]
  }

  statement {
    sid    = "AWSRedshiftAclCheck"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.this.arn]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      local.bucket_arn,
    ]
  }

}

module "observe_lambda_s3_bucket_subscription" {
  source  = "observeinc/lambda/aws//modules/s3_bucket_subscription"
  version = "3.3.0"

  lambda          = module.observe_lambda.lambda_function
  bucket_arns     = concat([local.s3_bucket.arn], var.subscribed_s3_bucket_arns)
  iam_name_prefix = local.name_prefix
  filter_prefix   = local.s3_exported_prefix
}
