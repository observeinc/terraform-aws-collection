variable "name" {
  type        = string
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

variable "destination" {
  type = object({
    arn    = string
    bucket = string
    prefix = string
  })
  nullable    = false
  description = "Destination filedrop"
}

variable "source_bucket_names" {
  description = <<-EOF
    A list of bucket names which the forwarder is allowed to read from.  This
    list only affects permissions, and supports wildcards. In order to have
    files copied to Filedrop, you must also subscribe S3 Bucket Notifications
    to the forwarder.
  EOF
  type        = list(string)
  nullable    = false
  default     = []
}

variable "source_topic_arns" {
  description = <<-EOF
    A list of SNS topics the forwarder is allowed to be subscribed to.
  EOF
  type        = list(string)
  nullable    = false
  default     = []
}

variable "source_kms_key_arns" {
  description = <<-EOF
    A list of KMS Key ARNs the forwarder is allowed to use to decrypt objects in S3.
  EOF
  type        = list(string)
  nullable    = false
  default     = []
}

variable "max_file_size" {
  description = <<-EOF
    Max file size for objects to process (in bytes), default is 1GB
  EOF
  type        = number
  nullable    = false
  default     = 1073741824
}

variable "content_type_overrides" {
  description = <<-EOF
      A list of key value pairs. The key is a regular expression which is
      applied to the S3 source (<bucket>/<key>) of forwarded files. The value
      is the content type to set for matching files. For example,
      `\.json$=application/x-ndjson` would forward all files ending in `.json`
      as newline delimited JSON
    EOF
  type = list(object({
    pattern      = string
    content_type = string
  }))
  nullable = false
  default  = []

  validation {
    condition     = can([for x in var.content_type_overrides : regexall(x.pattern, "")])
    error_message = "Override contains invalid regular expression pattern."
  }
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
  default     = 20
}

variable "lambda_env_vars" {
  description = "Environment variables to be passed into lambda."
  type        = map(string)
  nullable    = false
  default     = {}
}

variable "retention_in_days" {
  description = "Retention in days of cloudwatch log group"
  type        = number
  nullable    = false
  default     = 365
}

variable "queue_max_receive_count" {
  description = <<-EOF
    The number of times a message is delivered to the source queue before being
    moved to the dead-letter queue. A dead letter queue will only be created if
    this value is greater than 0.
  EOF
  type        = number
  nullable    = false
  default     = 4
}

variable "queue_delay_seconds" {
  description = <<-EOF
    The time in seconds that the delivery of all messages in the queue will be
    delayed. An integer from 0 to 900 (15 minutes).
  EOF
  type        = number
  nullable    = false
  default     = 0
}

variable "queue_message_retention_seconds" {
  description = <<-EOF
    Maximum amount of time a message will be retained in queue.
    This value applies to both source queue and dead letter queue if one
    exists.
  EOF
  type        = number
  nullable    = false
  default     = 345600
}

variable "queue_batch_size" {
  description = "Max number of items to process in single lambda execution"
  type        = number
  nullable    = false
  default     = 10
}

variable "queue_maximum_batching_window_in_seconds" {
  description = "The maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300)"
  type        = number
  nullable    = false
  default     = 1
}
