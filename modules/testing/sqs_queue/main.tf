resource "aws_sqs_queue" "this" {
  name_prefix = var.setup.short
}
