variable "name" {
  type        = string
  description = <<-EOF
    Name for resources.
  EOF
  default     = "observe-subscriber"
  nullable    = false
}

variable "filter_name" {
  description = "Subscription filter name. Existing filters that have this name as a prefix will be removed."
  type        = string
  default     = "observe-logs-subscription"
  nullable    = false
}

variable "filter_pattern" {
  description = "Subscription filter pattern."
  type        = string
  default     = ""
  nullable    = false
}

variable "destination_arn" {
  description = "Destination ARN for subscription filter. If null, any matching subscription filter will be removed"
  type        = string
  nullable    = true
  default     = null
}

variable "role_arn" {
  description = "Role ARN. Can only be set if destination_arn is also set."
  type        = string
  nullable    = true
  default     = null
}

variable "log_group_name_patterns" {
  description = "List of log group patterns to subscribe to."
  type        = list(string)
  default     = ["*"]
  nullable    = false
}

variable "log_group_name_prefixes" {
  description = "List of log group patterns to subscribe to."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "num_workers" {
  description = "Maximum number of concurrent workers when processing log groups."
  type        = number
  default     = null
  nullable    = true
}

variable "discovery_rate" {
  description = "Rate at which to trigger log group discovery."
  type        = string
  default     = "24 hours"
  nullable    = false
}

/*
  DiscoveryRate:
    Type: String
    Description: EventBridge rate expression for periodically triggering
      discovery. If not set, no eventbridge rules are configured.
    Default: ''
    AllowedPattern: '^([1-9]\d* (minute|hour|day)s?)?$'
  NameOverride:
    Type: String
    Description: >-
      Name of Lambda function.
    Default: ''


  */

variable "lambda_memory_size" {
  description = "Memory size for lambda function."
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout in seconds for lambda function."
  type        = number
  default     = 60
}

variable "lambda_env_vars" {
  description = "Environment variables to be passed into lambda."
  type        = map(string)
  default     = {}
}


variable "queue_max_receive_count" {
  description = <<-EOF
    The number of times a message is delivered to the source queue before being
    moved to the dead-letter queue. A dead letter queue will only be created if
    this value is greater than 0.
  EOF
  type        = number
  default     = 4
  nullable    = false
}

variable "queue_delay_seconds" {
  description = <<-EOF
    The time in seconds that the delivery of all messages in the queue will be
    delayed. An integer from 0 to 900 (15 minutes).
  EOF
  type        = number
  default     = 0
  nullable    = false
}

variable "queue_message_retention_seconds" {
  description = <<-EOF
    Maximum amount of time a message will be retained in queue.
    This value applies to both source queue and dead letter queue if one
    exists.
  EOF
  type        = number
  default     = 345600
  nullable    = false
}

variable "queue_batch_size" {
  description = "Max number of items to process in single lambda execution"
  type        = number
  default     = 1
}

variable "queue_maximum_batching_window_in_seconds" {
  description = "The maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300)"
  type        = number
  default     = 1
}
variable "retention_in_days" {
  description = "Retention in days of cloudwatch log group"
  type        = number
  default     = 365
  nullable    = false
}
