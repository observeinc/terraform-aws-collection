resource "random_string" "run" {
  length  = 8
  special = false
  upper   = false
}

locals {
  example       = basename(abspath(path.root))
  run_suffix    = coalesce(var.test_run_id, random_string.run.result)
  run_short     = substr(local.run_suffix, max(0, length(local.run_suffix) - 8), 8)
  name          = "tac-${local.run_suffix}-${local.example}"
  name_prefix   = "${local.name}-"
  bucket_prefix = substr("t-${local.run_short}-${substr(local.example, 0, 22)}-", 0, 37)
}

# We will subscribe this SNS topic
resource "aws_sns_topic" "this" {
  name_prefix = local.name_prefix
}

# To this S3 bucket
resource "aws_s3_bucket" "this" {
  bucket_prefix = local.bucket_prefix
}

# Via the forwarder
module "forwarder" {
  # Prefer using the hashicorp registry:
  # source = "observeinc/collection/aws//modules/forwarder"
  # For validation purposes we will instead refer to a local version of the
  # module:
  source = "../..//modules/forwarder"

  name = local.name
  destination = {
    bucket = aws_s3_bucket.this.id
  }

  # Allow sns:SendMessage from these topics
  source_topic_arns = [aws_sns_topic.this.arn]
}

# Subscribe SNS topic to forwarder's SQS queue which drives Lambda.
resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = module.forwarder.queue_arn
}
