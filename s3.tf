resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = format("%s-%s", var.name, random_string.bucket_suffix.result)
  acl           = "private"
  force_destroy = true
  tags          = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
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
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(local.elb_account_ids, data.aws_region.current.name, "missing")}:root"]
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
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
