variable "name" {
  type        = string
  nullable    = false
  description = <<-EOF
    Name of role. Since this name must be unique within the
    account, it will be reused for most of the resources created by this
    module.
  EOF

  validation {
    condition     = length(var.name) <= 64
    error_message = "Name must be under 64 characters."
  }
}

variable "destination_iam_arn" {
  description = "ARN for destination iam policy"
  type        = string
  nullable    = false
}

variable "firehose_arn" {
  description = "ARN for kinesis firehose"
  type        = string
  nullable    = false
}

variable "filter_name" {
  description = "Subscription filter name. Existing filters that have this name as a prefix will be removed."
  type        = string
  nullable    = false
  default     = "observe-logs-subscription"
}

variable "filter_pattern" {
  description = "Subscription filter pattern."
  type        = string
  nullable    = false
  default     = ""
}

variable "log_group_name_patterns" {
  description = "List of patterns as strings. We will only subscribe to log groups that have names matching one of the provided strings based on strings based on a case-sensitive substring search. To subscribe to all log groups, use the wildcard operator *."
  type        = list(string)
  nullable    = false
  default     = []

  validation {
    condition = alltrue([
      for prefix in var.log_group_name_patterns : (length(prefix) < 512 && can(regex("^(?!aws)([a-zA-Z0-9_\\-\\/\\.\\#]){1,512}", prefix))) || prefix == "*"
    ])
    error_message = "Invalid group name pattern provided. See https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogGroup.html for log group name restrictions."
  }
}

variable "log_group_name_prefixes" {
  description = "List of prefixes as strings. The lambda function will only apply to log groups that start with a provided string. To subscribe to all log groups, use the wildcard operator *."
  type        = list(string)
  nullable    = false
  default     = []

  validation {
    condition = alltrue([
      for prefix in var.log_group_name_prefixes : (length(prefix) < 512 && can(regex("^(?!aws)([a-zA-Z0-9_\\-\\/\\.\\#]){1,512}", prefix))) || prefix == "*"
    ])
    error_message = "Invalid group name prefix provided. See https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogGroup.html for log group name restrictions."
  }
}

variable "discovery_rate" {
  description = "EventBridge rate expression for periodically triggering discovery. If not set, no eventbridge rules are configured."
  type        = string
  validation {
    condition     = can(regex("^\\d+ (minutes|hours|days)$", var.discovery_rate))
    error_message = "Discovery_rate must be a valid rate expression of a positive number followed by (minutes|hours|days) ex. 10 minutes."
  }
}

variable "num_workers" {
  description = "Maximum number of concurrent workers when processing log groups."
  type        = number
  nullable    = false
  default     = 1
}

variable "lambda_memory_size" {
  description = "Memory size for lambda function."
  type        = number
  nullable    = false
  default     = 128
}

variable "lambda_timeout" {
  description = "Timeout in seconds for lambda function."
  type        = number
  nullable    = false
  default     = 20
}

variable "lambda_env_vars" {
  description = "Environment variables to be passed into lambda."
  type        = map(string)
  nullable    = false
  default     = {}
}
