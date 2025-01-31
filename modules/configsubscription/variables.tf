variable "target_arn" {
  description = <<-EOF
    Target ARN for eventbridge rule.
  EOF
  type        = string
}

variable "name_prefix" {
  type        = string
  description = <<-EOF
    Name prefix for resources.
  EOF
  default     = "observe-config-subscription-"
  nullable    = false
}

variable "aws_account_alias" {
  description = <<-EOF
    Override AWS account alias tag.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "tag_account_alias" {
  type        = bool
  description = <<-EOF
    Set tag based on account alias.
  EOF
  default     = true
  nullable    = false
}
