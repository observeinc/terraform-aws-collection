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
