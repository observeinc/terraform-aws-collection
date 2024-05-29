locals {
  name        = basename(abspath(path.root))
  name_prefix = "${local.name}-"
}

# We will subscribe this SNS topic
resource "aws_sns_topic" "this" {
  name_prefix = local.name_prefix
}

# To this S3 bucket
resource "aws_s3_bucket" "this" {
  bucket_prefix = local.name_prefix
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
