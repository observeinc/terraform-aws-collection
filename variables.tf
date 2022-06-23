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

variable "lambda_s3_custom_rules" {
  description = "List of rules to evaluate how to upload a given S3 object to Observe."
  type = list(object({
    pattern = string
    headers = map(string)
  }))
  default = []
}

variable "lambda_reserved_concurrent_executions" {
  description = "The number of simultaneous executions to reserve for the function."
  type        = number
  default     = 100
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


variable "subscribed_s3_bucket_arns" {
  description = "List of additional S3 bucket ARNs to subscribe lambda to."
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

variable "snapshot_include" {
  description = "List of actions to include in snapshot request."
  type        = list(string)
  default     = []
}

variable "snapshot_exclude" {
  description = "List of actions to exclude from being executed on snapshot request."
  type        = list(string)
  default     = []
}

variable "snapshot_schedule_expression" {
  description = "Rate at which snapshot is triggered. Must be valid EventBridge expression"
  type        = string
  default     = "rate(3 hours)"
}

variable "kms_key_id" {
  description = "KMS key ARN to use to encrypt the logs delivered by CloudTrail."
  type        = string
  default     = ""
}

variable "cloudtrail_enable" {
  description = <<-EOF
    Whether to create a CloudTrail trail.
    
    Useful for avoiding the 'trails per region' quota of 5, such as when testing.
  EOF
  type        = bool
  default     = true
}

variable "cloudtrail_enable_log_file_validation" {
  description = "Whether log file integrity validation is enabled for CloudTrail. Defalults to false."
  type        = bool
  default     = false
}


variable "cloudwatch_metrics_include_filters" {
  description = "Namespaces to include. Mutually exclusive with cloudwatch_metrics_exclude_filters."
  type        = list(string)
  default     = []
}

variable "cloudwatch_metrics_exclude_filters" {
  description = "Namespaces to exclude. Mutually exclusive with cloudwatch_metrics_include_filters."
  type        = list(string)
  default     = []
}
