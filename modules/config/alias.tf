data "aws_iam_account_alias" "current" {
  count = var.tag_account_alias ? 1 : 0
}

locals {
  tags = var.tag_account_alias ? {
    "observeinc.com/accountalias" = data.aws_iam_account_alias.current[0].account_alias
  } : {}
}
