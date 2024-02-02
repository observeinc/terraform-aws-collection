module "config" {
  count = var.include_resource_types != null ? 1 : 0

  source = "../config"

  name                   = "default"
  bucket                 = aws_s3_bucket.this.id
  sns_topic_arn          = aws_sns_topic.this.arn
  include_resource_types = var.include_resource_types
  exclude_resource_types = var.exclude_resource_types

  delivery_frequency            = lookup(var.config_variables, "delivery_frequency", null)
  include_global_resource_types = lookup(var.config_variables, "include_global_resource_types", null)

  depends_on = [aws_s3_bucket_notification.this]
}
