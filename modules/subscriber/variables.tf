variable "name" {
  type        = string
  nullable    = false
  description = <<-EOF
    Name for resources.
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
  description = <<-EOF
    List of log group name patterns. A log group is subscribed if its name
    matches any pattern. Patterns matched using regexp.MatchString() (partial match),
    so a plain string like "/aws/lambda" matches any log group whose name
    contains that substring.

    To subscribe to all log groups, use the special token "*". The "*"
    character selects all log groups.

    Matching is regex-based, characters like "." are treated
    as regex metacharacters (matching any character), not literals.

    Examples:
      ["*"]                - subscribe to all log groups
      ["/aws/lambda"]      - subscribe to any log group containing "/aws/lambda"
  EOF
  type        = list(string)
  nullable    = false
  default     = []

  validation {
    condition = alltrue([
      for pattern in var.log_group_name_patterns : can(regex("[a-zA-Z0-9_\\-\\/\\.\\#]{1,512}", pattern)) || pattern == "*"
    ])
    error_message = "Invalid group name pattern provided. See https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogGroup.html for log group name restrictions."
  }
}

variable "log_group_name_prefixes" {
  description = <<-EOF
    List of log group name prefixes. A log group is subscribed if its name
    starts with any of the provided strings. Internally each prefix is
    converted to the regex "^<prefix>.*" and matched using
    regexp.MatchString().

    To subscribe to all log groups, use the special token "*". The "*"
    character selects all log groups; it is not a glob wildcard.

    Examples:
      ["*"]           - subscribe to all log groups
      ["/aws/lambda"] - subscribe to log groups whose names start with "/aws/lambda"
  EOF
  type        = list(string)
  nullable    = false
  default     = []

  validation {
    condition = alltrue([
      for prefix in var.log_group_name_prefixes : can(regex("[a-zA-Z0-9_\\-\\/\\.\\#]{1,512}", prefix)) || prefix == "*"
    ])
    error_message = "Invalid group name prefix provided. See https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogGroup.html for log group name restrictions."
  }
}

variable "exclude_log_group_name_patterns" {
  description = <<-EOF
    List of Go regular expression patterns. Any log group whose name matches
    a pattern is excluded from subscription, even if it matches an include
    pattern. Patterns are joined with "|" into a single regex and matched
    using regexp.MatchString() (partial match), so the pattern only needs to
    appear somewhere in the log group name.

    Exclusions take precedence over log_group_name_patterns and
    log_group_name_prefixes.

    Examples:
      ["/aws/lambda/noisy-fn"]   - exclude log groups containing "/aws/lambda/noisy-fn"
      ["^/aws/elasticbeanstalk"] - exclude log groups starting with "/aws/elasticbeanstalk"
      ["/aws/lambda", "/aws/ecs"] - exclude log groups containing either substring
  EOF
  type        = list(string)
  nullable    = false
  default     = []

  validation {
    condition = alltrue([
      for pattern in var.exclude_log_group_name_patterns : can(regexall(pattern, ""))
    ])
    error_message = "Invalid group name pattern provided. See https://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogGroup.html for log group name restrictions."
  }
}

variable "discovery_rate" {
  description = "EventBridge scheduler rate expression for periodically triggering discovery. If not set, no scheduler is configured."
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = can(regex("^(\\d+ (minutes|hours|days))?$", var.discovery_rate))
    error_message = "Value is not a valid EventBridge scheduler rate expression (https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html#rate-based)."
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
  default     = 120
}

variable "lambda_env_vars" {
  description = "Environment variables to be passed into lambda."
  type        = map(string)
  nullable    = false
  default     = {}
}

variable "lambda_runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "provided.al2023"
  nullable    = false
}

variable "debug_endpoint" {
  description = "Endpoint to send debugging telemetry to. Sets the OTEL_EXPORTER_OTLP_ENDPOINT environment variable for the lambda function."
  type        = string
  nullable    = false
  default     = ""
}

variable "verbosity" {
  description = "Logging verbosity for Lambda. Highest log verbosity is 9."
  type        = number
  nullable    = false
  default     = 1
}

variable "sam_release_version" {
  description = "Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps."
  type        = string
  default     = null
}

variable "code_uri" {
  description = "S3 URI for lambda binary. If set, takes precedence over sam_release_version."
  type        = string
  default     = ""
  nullable    = false
}

variable "retention_in_days" {
  description = "Retention in days for cloudwatch log group."
  type        = number
  nullable    = false
  default     = 365
}

variable "cloudwatch_log_kms_key" {
  description = "KMS key to use for cloudwatch log encryption."
  type        = string
  nullable    = true
  default     = null
}

variable "tags" {
  description = "Tags to add to the resources."
  type        = map(string)
  default     = {}
}

variable "dead_letter_queue_tags" {
  description = "Tags to add to the deadletter queue. Merged with tags variable, with these taking precedence for any overlapping keys."
  type        = map(string)
  default     = {}
}