locals {
  bucket_name = format("%s-%s", var.name, random_string.bucket_suffix.result)
}

resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = local.bucket_name
  acl           = "log-delivery-write"
  force_destroy = true
  tags          = var.tags

  logging {
    target_bucket = local.bucket_name
    target_prefix = var.s3_exported_prefix
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "observe_lambda_s3_bucket_subscription" {
  source = "github.com/observeinc/terraform-aws-lambda?ref=v0.5.0//s3_bucket_subscription"
  lambda = module.observe_lambda.lambda_function
  bucket = aws_s3_bucket.bucket

  iam_name_prefix = local.name_prefix
  filter_prefix   = var.s3_exported_prefix
}


data "aws_iam_policy_document" "s3_policy" {

  statement {
    sid     = "AclCheck"
    actions = ["s3:GetBucketAcl"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    resources = [
      aws_s3_bucket.bucket.arn,
    ]
  }

  statement {
    sid     = "PutObject"
    actions = ["s3:PutObject"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    resources = [
      "${aws_s3_bucket.bucket.arn}/${var.s3_exported_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid     = "ElasticLoadBalancingWrite"
    actions = ["s3:PutObject"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(local.elb_account_ids, data.aws_region.current.name, "missing")}:root"]
    }

    resources = [
      "${aws_s3_bucket.bucket.arn}/${var.s3_exported_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
