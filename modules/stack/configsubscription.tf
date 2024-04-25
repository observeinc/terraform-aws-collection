module "configsubscription" {
  count  = var.config_delivery_bucket_name != "" ? 1 : 0
  source = "../configsubscription"

  name_prefix = local.name_prefix
  target_arn  = module.forwarder.queue_arn
}

