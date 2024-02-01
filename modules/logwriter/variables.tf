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

variable "bucket_arn" {
  description = "S3 Bucket ARN to write log records to."
  type        = string
  nullable    = false
}

variable "prefix" {
  description = "Optional prefix to write log records to."
  type        = string
  nullable    = false
  default     = "observe"
}

variable "buffering_interval" {
  description = <<-EOF
    Buffer incoming data for the specified period of time, in seconds, before
    delivering it to S3.
  EOF
  type        = number
  nullable    = false
  default     = 60
}

variable "buffering_size" {
  description = <<-EOF
    Buffer incoming data to the specified size, in MiBs, before delivering it
    to S3.
  EOF
  type        = number
  nullable    = false
  default     = 1
}

variable "filter_name" {
  description = "Subscription filter name. Existing filters that have this name as a prefix will be removed."
  type        = string
  default     = null
}

variable "filter_pattern" {
  description = "Subscription filter pattern."
  type        = string
  default     = null
}

variable "log_group_name_patterns" {
  description = "List of patterns as strings. We will only subscribe to log groups that have names matching one of the provided strings based on strings based on a case-sensitive substring search. To subscribe to all log groups, use the wildcard operator *."
  type        = list(string)
  default     = null
}

variable "log_group_name_prefixes" {
  description = "List of prefixes as strings. The lambda function will only apply to log groups that start with a provided string. To subscribe to all log groups, use the wildcard operator *."
  type        = list(string)
  default     = null
}

variable "num_workers" {
  description = "Maximum number of concurrent workers when processing log groups."
  type        = number
  default     = null
}

variable "discovery_rate" {
  description = "EventBridge rate expression for periodically triggering discovery. If not set, no eventbridge rules are configured."
  type        = string
  default     = null
}

variable "lambda_memory_size" {
  description = "Memory size for lambda function."
  type        = number
  default     = null
}

variable "lambda_timeout" {
  description = "Timeout in seconds for lambda function."
  type        = number
  default     = null
}

variable "lambda_env_vars" {
  description = "Environment variables to be passed into lambda."
  type        = map(string)
  default     = null
}
