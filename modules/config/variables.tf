variable "name" {
  description = "Name to set on AWS Config resources."
  type        = string
  default     = "default"
  nullable    = false
}

variable "bucket" {
  type        = string
  description = "The name of the S3 bucket used to store the configuration history."
  nullable    = false
}

variable "prefix" {
  description = "The prefix for the specified S3 bucket."
  type        = string
  default     = ""
  nullable    = false
}

variable "delivery_frequency" {
  description = "The frequency with which AWS Config recurringly delivers configuration snapshots"
  type        = string
  default     = "Three_Hours"
  nullable    = false
}

variable "include_global_resource_types" {
  description = <<-EOF
    Specifies whether AWS Config includes all supported types of global
    resources with the resources that it records.
  EOF
  type        = bool
  default     = true
  nullable    = true
}

variable "sns_topic_arn" {
  description = <<-EOF
    The ARN of the SNS topic that AWS Config delivers notifications to.
  EOF
  type        = string
  default     = null
  nullable    = true
}
