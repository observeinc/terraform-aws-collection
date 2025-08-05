module "config" {
  count  = var.config != null ? 1 : 0
  source = "../config"

  name          = "default"
  bucket        = aws_s3_bucket.this.id
  sns_topic_arn = aws_sns_topic.this.arn

  include_resource_types        = var.config.include_resource_types
  exclude_resource_types        = var.config.exclude_resource_types
  delivery_frequency            = var.config.delivery_frequency
  include_global_resource_types = var.config.include_global_resource_types
  tag_account_alias             = var.config.tag_account_alias
  aws_account_alias             = var.config.aws_account_alias

  depends_on = [aws_s3_bucket_notification.this]
}
