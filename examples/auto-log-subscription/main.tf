locals {
  name        = basename(abspath(path.root))
  name_prefix = "${local.name}-"
}

# This is the bucket where data will be written to.
resource "aws_s3_bucket" "this" {
  bucket_prefix = local.name_prefix
  force_destroy = true
}

# We will include this log group in our subscription
resource "aws_cloudwatch_log_group" "included" {
  name_prefix = local.name_prefix
}

# We will exclude this log group from our subscription.
resource "aws_cloudwatch_log_group" "excluded" {
  name_prefix = "${local.name_prefix}exclude"
}

# Install logwriter module, pointing at our destination bucket.
module "logwriter" {
  # Prefer using the hashicorp registry:
  # source = "observeinc/collection/aws//modules/logwriter"
  # For validation purposes we will instead refer to a local version of the
  # module:
  source = "../..//modules/logwriter"

  name       = local.name
  bucket_arn = aws_s3_bucket.this.arn

  log_group_name_prefixes         = [local.name_prefix]
  exclude_log_group_name_patterns = ["exclude"]

  # How often do we want to scan for unsubscribed log groups?
  # If not set, log groups only get discovered on creation.
  discovery_rate = "1 hours"
}
