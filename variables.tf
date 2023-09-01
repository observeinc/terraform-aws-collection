variable "name" {
  description = "Name for resources to be created"
  type        = string
  default     = "observe-collection"
}

variable "log_subscription_name" {
  description = "Name for log subscription resources to be created"
  type        = string
  default     = null
}

variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe Token"
  type        = string

  validation {
    condition     = contains(split("", var.observe_token), ":")
    error_message = "Token format does not follow {datastream_id}:{datastream_secret} format."
  }
}

variable "observe_domain" {
  description = "Observe Domain"
  type        = string
  default     = "observeinc.com"
}

variable "snapshot_action" {
  description = "List of actions triggered by snapshot. Set to null to inherit all actions supported by the lambda."
  type        = set(string)
  nullable    = true
  default = [
    "autoscaling:Describe*",
    "cloudformation:Describe*",
    "cloudformation:List*",
    "cloudfront:List*",
    "dynamodb:Describe*",
    "dynamodb:List*",
    "ec2:Describe*",
    "ecs:Describe*",
    "ecs:List*",
    "eks:Describe*",
    "eks:List*",
    "elasticache:Describe*",
    "elasticloadbalancing:Describe*",
    "events:List*",
    "firehose:Describe*",
    "firehose:List*",
    "iam:Get*",
    "iam:List*",
    "kinesis:Describe*",
    "kinesis:List*",
    "lambda:List*",
    "logs:Describe*",
    "organizations:List*",
    "rds:Describe*",
    "route53:List*",
    "s3:GetBucket*",
    "s3:List*",
    "sns:Get*",
    "sns:List*",
    "sqs:Get*",
    "sqs:List*"
  ]
}

variable "lambda_memory_size" {
  description = <<-EOF
    The amount of memory that your function has access to. Increasing the function's memory also increases its CPU allocation.
    The default value is 256 MB. The value must be a multiple of 64 MB.
  EOF
  type        = number
  nullable    = false
  default     = 256
}

variable "lambda_timeout" {
  description = <<-EOF
    The amount of time that Lambda allows a function to run before stopping it.
    The maximum allowed value is 900 seconds.
  EOF
  type        = number
  nullable    = false
  default     = 120
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

variable "lambda_subscribe_logs" {
  description = "Whether to subscribe to the Lambda function's logs and deliver them from CloudWatch to Observe via Kinesis Firehose."
  type        = bool
  default     = true
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

variable "subscribed_s3_bucket_arns" {
  description = "List of additional S3 bucket ARNs to subscribe lambda to."
  type        = list(string)
  default     = []
}

variable "subscribed_log_group_matches" {
  description = <<-EOF
    A list of regex patterns describing CloudWatch log groups to subscribe to.

    See https://github.com/observeinc/terraform-aws-cloudwatch-logs-subscription#input_log_group_matches for more info"
  EOF
  type        = list(string)
  default     = []
}

variable "subscribed_log_group_excludes" {
  description = <<-EOF
    A list of regex patterns describing CloudWatch log groups to NOT subscribe to.

    See https://github.com/observeinc/terraform-aws-cloudwatch-logs-subscription#input_log_group_excludes for more info"
  EOF
  type        = list(string)
  default     = []
}

variable "subscribed_log_group_filter_pattern" {
  description = <<-EOF
    A filter pattern for a CloudWatch Logs subscription filter.

    See https://github.com/observeinc/terraform-aws-cloudwatch-logs-subscription#input_filter_pattern or
    https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html for more info"
  EOF
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
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
  default     = "rate(1 hour)"
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

variable "cloudtrail_exclude_management_event_sources" {
  description = <<-EOF
    A list of management event sources to exclude.

    See the following link for more info:
    https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html
  EOF
  type        = set(string)
  default = [
    "kms.amazonaws.com",
    "rdsdata.amazonaws.com",
  ]
}

variable "cloudwatch_metrics_include_filters" {
  description = "Namespaces to include. Mutually exclusive with cloudwatch_metrics_exclude_filters."
  type        = set(string)
  nullable    = false
  default     = []
}

variable "cloudwatch_metrics_exclude_filters" {
  description = <<-EOF
    Namespaces to exclude. Mutually exclusive with cloudwatch_metrics_include_filters.

    To disable Cloudwatch Metrics Stream entirely, use ["*"].
  EOF
  type        = set(string)
  nullable    = false
  default     = []
}

variable "eventbridge_rules" {
  description = <<-EOF
    Eventbridge events matching these rules will be forwarded to Observe. Map
    keys are only used to provide stable resource addresses.

    If null, a default set of rules will be used.
  EOF
  type = map(object({
    description   = string
    event_pattern = string
  }))
  default = null
}

variable "s3_bucket" {
  description = <<-EOF
    Override S3 bucket used to to stage data to be sent to Observe.
  EOF
  type = object({
    id  = string
    arn = string
  })
  default = null
}

variable "invoke_snapshot_on_start_enabled" {
  description = "Toggle invocation of snapshot from Cloudformation. This can be useful for debug purposes if the lambda fails to complete successfully."
  type        = bool
  default     = true
}
