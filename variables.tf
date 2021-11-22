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

variable "snapshot_action" {
  description = "List of actions allow by policy and periodically triggered."
  type        = list(string)
  default = [
    "autoscaling:Describe*",
    "cloudformation:Describe*",
    "dynamodb:Describe*",
    "dynamodb:List*",
    "ec2:Describe*",
    "ecs:Describe*",
    "ecs:List*",
    "elasticache:Describe*",
    "elasticloadbalancing:Describe*",
    "events:List*",
    "firehose:Describe*",
    "firehose:List*",
    "iam:Get*",
    "iam:List*",
    "kinesis:Describe*",
    "kinesis:List*",
    "kms:Describe*",
    "kms:List*",
    "lambda:List*",
    "logs:Describe*",
    "organizations:Describe*",
    "organizations:List*",
    "rds:Describe*",
    "redshift:Describe*",
    "route53:List*",
    "s3:GetBucket*",
    "s3:List*",
    "secretsmanager:List*",
    "sns:Get*",
    "sns:List*",
    "sqs:Get*",
    "sqs:List*",
  ]
}

variable "snapshot_exclude" {
  description = "List of actions to exclude from being executed on snapshot request."
  type        = list(string)
  default     = []
}
