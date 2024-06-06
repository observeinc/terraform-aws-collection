module "forwarder" {
  source = "../forwarder"

  name        = var.name
  destination = var.destination

  source_bucket_names = compact(concat([
    aws_s3_bucket.this.id,
    var.configsubscription != null ? var.configsubscription.delivery_bucket_name : "",
  ], var.forwarder.source_bucket_names))
  source_topic_arns                        = concat([aws_sns_topic.this.arn], var.forwarder.source_topic_arns)
  content_type_overrides                   = local.content_type_overrides
  max_file_size                            = var.forwarder.max_file_size
  lambda_memory_size                       = var.forwarder.lambda_memory_size
  lambda_timeout                           = var.forwarder.lambda_timeout
  lambda_env_vars                          = var.forwarder.lambda_env_vars
  retention_in_days                        = var.forwarder.retention_in_days
  queue_max_receive_count                  = var.forwarder.queue_max_receive_count
  queue_delay_seconds                      = var.forwarder.queue_delay_seconds
  queue_message_retention_seconds          = var.forwarder.queue_message_retention_seconds
  queue_batch_size                         = var.forwarder.queue_batch_size
  queue_maximum_batching_window_in_seconds = var.forwarder.queue_maximum_batching_window_in_seconds
  debug_endpoint                           = var.debug_endpoint
  verbosity                                = var.verbosity
  code_uri                                 = var.forwarder.code_uri
  code_version                             = try(coalesce(var.forwarder.code_version, var.code_version), null)
}
