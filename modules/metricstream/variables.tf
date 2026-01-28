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
}

variable "prefix" {
  description = "Optional prefix to write log records to."
  type        = string
  nullable    = false
  default     = ""
}

variable "output_format" {
  description = "The output format for CloudWatch Metrics."
  type        = string
  nullable    = false
  default     = "json"

  validation {
    condition     = contains(["json", "opentelemetry0.7", "opentelemetry1.0"], var.output_format)
    error_message = "Unexpected output format."
  }
}

variable "include_filters" {
  description = <<-EOF
    List of inclusion filters. If neither include_filters or exclude_filters is
    set, a default filter will be used.
  EOF
  type = list(object({
    namespace    = string
    metric_names = list(string)
  }))
  default = null
}

variable "exclude_filters" {
  description = <<-EOF
    List of exclusion filters. Mutually exclusive with inclusion filters.
  EOF
  type = list(object({
    namespace    = string
    metric_names = list(string)
  }))
  default = null
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

variable "sam_release_version" {
  description = "Release version for SAM apps as defined on github.com/observeinc/aws-sam-apps."
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