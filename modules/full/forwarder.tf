module "forwarder" {
  source = "../forwarder"

  name                   = var.name
  destination            = var.destination
  source_bucket_names    = concat([aws_s3_bucket.this.id], var.source_bucket_names)
  source_topic_arns      = concat([aws_sns_topic.this.arn], var.source_topic_arns)
  content_type_overrides = var.content_type_overrides

  max_file_size                            = lookup(var.forwarder_variables, "max_file_size", null)
  lambda_memory_size                       = lookup(var.forwarder_variables, "lambda_memory_size", null)
  lambda_timeout                           = lookup(var.forwarder_variables, "lambda_timeout", null)
  lambda_env_vars                          = lookup(var.forwarder_variables, "lambda_env_vars", null)
  retention_in_days                        = lookup(var.forwarder_variables, "retention_in_days", null)
  queue_max_receive_count                  = lookup(var.forwarder_variables, "queue_max_receive_count", null)
  queue_delay_seconds                      = lookup(var.forwarder_variables, "queue_delay_seconds", null)
  queue_message_retention_seconds          = lookup(var.forwarder_variables, "queue_message_retention_seconds", null)
  queue_batch_size                         = lookup(var.forwarder_variables, "queue_batch_size", null)
  queue_maximum_batching_window_in_seconds = lookup(var.forwarder_variables, "queue_maximum_batching_window_in_seconds", null)
}
