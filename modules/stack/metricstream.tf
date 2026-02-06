module "metricstream" {
  count  = var.metricstream != null ? 1 : 0
  source = "../metricstream"

  name       = "${var.name}-metricstream"
  bucket_arn = aws_s3_bucket.this.arn

  include_filters        = var.metricstream.include_filters
  exclude_filters        = var.metricstream.exclude_filters
  buffering_interval     = var.metricstream.buffering_interval
  buffering_size         = var.metricstream.buffering_size
  sam_release_version    = try(coalesce(var.metricstream.sam_release_version, var.sam_release_version), null)
  cloudwatch_log_kms_key = var.metricstream.cloudwatch_log_kms_key
  retention_in_days      = var.metricstream.retention_in_days
  tags                   = var.tags
}
