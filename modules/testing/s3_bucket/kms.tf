resource "aws_kms_key" "this" {
  count               = var.kms_key_policy_json != "" ? 1 : 0
  enable_key_rotation = true
  policy              = var.kms_key_policy_json
}

resource "aws_kms_alias" "this" {
  count         = length(aws_kms_key.this)
  name          = "alias/${var.setup.short}"
  target_key_id = aws_kms_key.this[0].key_id
}
