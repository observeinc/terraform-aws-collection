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

variable "bucket_arn" {
  description = <<-EOF
    S3 Bucket ARN to write log records to.
  EOF
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^arn:.*", var.bucket_arn))
    error_message = "ARN is invalid."
  }
}

variable "prefix" {
  description = "Optional prefix to write log records to."
  type        = string
  nullable    = false
  default     = ""
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
  description = <<-EOF
    Subscription filter name. Existing filters that have this name as a prefix
    will be removed.
  EOF
  type        = string
  default     = null
}

variable "filter_pattern" {
  description = <<-EOF
    Subscription filter pattern.
  EOF
  type        = string
  default     = null
}

variable "log_group_name_patterns" {
  description = <<-EOF
    Subscribe to CloudWatch log groups matching any of the provided patterns
    based on a case-sensitive substring search. To subscribe to all log groups
    use the wildcard operator *.
  EOF
  type        = list(string)
  default     = null
}

variable "log_group_name_prefixes" {
  description = <<-EOF
    Subscribe to CloudWatch log groups matching any of the provided prefixes.
    To subscribe to all log groups use the wildcard operator *.
  EOF
  type        = list(string)
  default     = null
}

variable "exclude_log_group_name_patterns" {
  description = <<-EOF
    Exclude any log group names matching the provided set of regular
    expressions.
  EOF
  type        = list(string)
  default     = null
}

variable "num_workers" {
  description = <<-EOF
    Maximum number of concurrent workers when processing log groups.
  EOF
  type        = number
  default     = null
}

variable "discovery_rate" {
  description = <<-EOF
    EventBridge rate expression for periodically triggering discovery. If not
    set, no eventbridge rules are configured.
  EOF
  type        = string
  default     = null
}

variable "lambda_memory_size" {
  description = <<-EOF
    Memory size for lambda function.
  EOF
  type        = number
  default     = null
}

variable "lambda_timeout" {
  description = <<-EOF
    Timeout in seconds for lambda function.
  EOF
  type        = number
  default     = null
}

variable "lambda_env_vars" {
  description = <<-EOF
    Environment variables to be passed into lambda.
  EOF
  type        = map(string)
  default     = null
}

variable "debug_endpoint" {
  description = "Endpoint to send debugging telemetry to. Sets the OTEL_EXPORTER_OTLP_ENDPOINT environment variable for the lambda function."
  type        = string
  default     = null
}

variable "verbosity" {
  description = "Logging verbosity for Lambda. Highest log verbosity is 9."
  type        = number
  default     = null
}

variable "sam_release_version" {
  description = "Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps."
  type        = string
  default     = null
}

variable "code_uri" {
  description = "S3 URI for lambda binary. If set, takes precedence over sam_release_version."
  type        = string
  default     = null
}
