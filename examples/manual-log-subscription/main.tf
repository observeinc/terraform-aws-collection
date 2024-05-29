locals {
  name        = basename(abspath(path.root))
  name_prefix = "${local.name}-"
}

# This is the log group we will collect data for.
resource "aws_cloudwatch_log_group" "this" {
  name_prefix = local.name_prefix
}

# This is the bucket where data will be written to.
resource "aws_s3_bucket" "this" {
  bucket_prefix = local.name_prefix
  force_destroy = true
}


# Install logwriter module, pointing at our destination bucket.
# If no other variables are provided, the logwriter module will not attempt to
# auto-subscribe to log groups.
module "logwriter" {
  # Prefer using the hashicorp registry:
  # source = "observeinc/collection/aws//modules/logwriter"
  # For validation purposes we will instead refer to a local version of the
  # module:
  source = "../..//modules/logwriter"

  name       = local.name
  bucket_arn = aws_s3_bucket.this.arn
}

# We can manually subscribe individual log groups by referencing the module
# outputs.
resource "aws_cloudwatch_log_subscription_filter" "this" {
  name           = "observe_subsription"
  log_group_name = aws_cloudwatch_log_group.this.name

  role_arn        = module.logwriter.destination_role_arn
  destination_arn = module.logwriter.firehose_arn
  filter_pattern  = ""
}
