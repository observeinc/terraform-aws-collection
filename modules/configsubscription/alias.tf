data "aws_iam_account_alias" "current" {
  count = var.tag_account_alias && var.aws_account_alias == null ? 1 : 0
}

locals {
  tags = var.tag_account_alias ? {
    "observeinc.com/accountalias" = var.aws_account_alias == null ? data.aws_iam_account_alias.current[0].account_alias : var.aws_account_alias
  } : {}
}
