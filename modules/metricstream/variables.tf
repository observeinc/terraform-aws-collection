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
    List of inclusion filters.
  EOF
  type = list(object({
    namespace    = string
    metric_names = list(string)
  }))
  default  = []
  nullable = false
}

variable "exclude_filters" {
  description = <<-EOF
    List of exclusion filters. Mutually exclusive with inclusion filters
  EOF
  type = list(object({
    namespace    = string
    metric_names = list(string)
  }))
  default  = []
  nullable = false
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
