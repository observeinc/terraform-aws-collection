resource "aws_kms_key" "this" {
  count               = var.kms_key_policy_json != "" ? 1 : 0
  enable_key_rotation = true
  policy              = var.kms_key_policy_json
}
