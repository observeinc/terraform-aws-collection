variable "name" {
  description = "Name for resources to be created"
  type        = string
  default     = "observe-collection"
}

variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe Token"
  type        = string
}

variable "observe_domain" {
  description = "Observe Domain"
  type        = string
  default     = "observeinc.com"
}

variable "lambda_version" {
  description = "Lambda version"
  type        = string
  default     = "latest"
}

variable "retention_in_days" {
  description = "Retention in days of cloudwatch log group"
  type        = number
  default     = 365
}

variable "lambda_envvars" {
  description = "Environment variables"
  type        = map(any)
  default     = {}
}

variable "dead_letter_queue_destination" {
  type        = string
  default     = null
  description = "Send failed events/function executions to a dead letter queue arn sns or sqs"
}

variable "subscribed_log_group_names" {
  description = "Log groups to subscribe to"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cloudwatch_logs_subscribe_to_firehose" {
  description = "Subscribe cloudwatch logs to firehose"
  type        = bool
  default     = true
}

variable "cloudwatch_logs_subscribe_to_lambda" {
  description = "Subscribe cloudwatch logs to Lambda"
  type        = bool
  default     = false
}

variable "cloudtrail_is_multi_region_trail" {
  description = "Whether to enable multi region trail export"
  type        = bool
  default     = true
}

variable "s3_exported_prefix" {
  description = "Key prefix which is subscribed to be sent to Observe Lambda"
  type        = string
  default     = ""
}

variable "s3_logging" {
  description = "Enable S3 access log collection"
  type        = bool
  default     = false
}

variable "s3_lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}
