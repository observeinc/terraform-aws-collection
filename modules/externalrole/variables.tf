variable "name" {
  type        = string
  nullable    = false
  description = <<-EOF
    Name for IAM role.
  EOF

  validation {
    condition     = length(var.name) <= 64
    error_message = "Name must be under 64 characters."
  }
}

variable "observe_aws_account_id" {
  description = "AWS account ID for Observe tenant"
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^\\d{12}$", var.observe_aws_account_id))
    error_message = "Account ID must have 12 digits."
  }
}

variable "datastream_ids" {
  description = <<-EOF
    Observe datastreams collected data is intended for.
  EOF
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.datastream_ids) > 0
    error_message = "At least one datastream must be provided."
  }
}

variable "allowed_actions" {
  description = <<-EOF
    Set of IAM actions external entity is allowed to perform.
  EOF
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.allowed_actions) > 0
    error_message = "At least one action must be provided."
  }
}
