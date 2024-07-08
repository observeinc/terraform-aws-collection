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
  description = <<-EOF
    The frequency with which AWS Config recurringly delivers configuration
    snapshots. Valid values: One_Hour, Three_Hours, Six_Hours, Twelve_Hours,
    TwentyFour_Hours
    (https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigSnapshotDeliveryProperties.html)."
    EOF
  type        = string
  default     = "Three_Hours"
  nullable    = false

  validation {
    condition     = contains(["One_Hour", "Three_Hours", "Six_Hours", "Twelve_Hours", "TwentyFour_Hours"], var.delivery_frequency)
    error_message = "unsupported delivery frequency value."
  }
}

variable "include_resource_types" {
  description = <<-EOF
    Restrict configuration collection to a subset of resource types.
  EOF
  type        = list(string)
  default     = ["*"]
  nullable    = false

  validation {
    condition     = length(var.include_resource_types) > 0
    error_message = "include_resource_types cannot be empty, otherwise module would not be needed."
  }
}

variable "exclude_resource_types" {
  description = <<-EOF
    Exclude a subset of resource types from configuration collection. This
    parameter is mutually exclusive with IncludeResourceTypes.
  EOF
  type        = list(string)
  default     = []
  nullable    = false
}

variable "include_global_resource_types" {
  description = <<-EOF
    Specifies whether AWS Config includes all supported types of global
    resources with the resources that it records. This field only takes
    effect if all resources are included for collection. include_resource_types
    must be set to *, and exclude_resource_types must not be set.
  EOF
  type        = bool
  default     = true
  nullable    = false
}

variable "sns_topic_arn" {
  description = <<-EOF
    The ARN of the SNS topic that AWS Config delivers notifications to.
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
