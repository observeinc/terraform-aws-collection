resource "aws_cloudtrail" "trail" {
  count = var.cloudtrail_enable ? 1 : 0

  name                       = var.name
  s3_bucket_name             = local.s3_bucket.id
  s3_key_prefix              = trimsuffix(local.s3_exported_prefix, "/")
  is_multi_region_trail      = var.cloudtrail_is_multi_region_trail
  kms_key_id                 = var.kms_key_id
  enable_log_file_validation = var.cloudtrail_enable_log_file_validation

  dynamic "event_selector" {
    for_each = length(var.cloudtrail_exclude_management_event_sources) > 0 ? ["ok"] : []
    content {
      exclude_management_event_sources = var.cloudtrail_exclude_management_event_sources
    }
  }
}
