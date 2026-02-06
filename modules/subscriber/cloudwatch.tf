resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key
  tags              = var.tags
}
