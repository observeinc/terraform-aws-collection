module "configsubscription" {
  count  = var.configsubscription != null ? 1 : 0
  source = "../configsubscription"

  name_prefix = local.name_prefix
  target_arn  = module.forwarder.queue_arn

  tag_account_alias = var.configsubscription.tag_account_alias
  aws_account_alias = var.configsubscription.aws_account_alias
}

