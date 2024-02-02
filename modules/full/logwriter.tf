module "logwriter" {
  source = "../logwriter"

  name = "${var.name}-logwriter"

  bucket_arn              = aws_s3_bucket.this.arn
  prefix                  = "cloudwatchlogs/"
  log_group_name_patterns = var.log_group_name_patterns
  log_group_name_prefixes = var.log_group_name_prefixes

  buffering_interval = lookup(var.logwriter_variables, "buffering_interval", null)
  buffering_size     = lookup(var.logwriter_variables, "buffering_size", null)
  filter_name        = lookup(var.logwriter_variables, "filter_name", null)
  filter_pattern     = lookup(var.logwriter_variables, "filter_pattern", null)
  num_workers        = lookup(var.logwriter_variables, "num_workers", null)
  discovery_rate     = lookup(var.logwriter_variables, "discovery_rate", null)
  lambda_memory_size = lookup(var.logwriter_variables, "lambda_memory_size", null)
  lambda_timeout     = lookup(var.logwriter_variables, "lambda_timeout", null)

  depends_on = [aws_s3_bucket_notification.this]
}
