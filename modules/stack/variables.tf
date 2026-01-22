variable "name" {
  type        = string
  description = <<-EOF
    Name of role. Since this name must be unique within the
    account, it will be reused for most of the resources created by this
    module.
  EOF

  validation {
    condition     = length(var.name) <= 50
    error_message = "Name must be at most 50 characters long."
  }
}

variable "destination" {
  type = object({
    arn    = optional(string, "")
    bucket = optional(string, "")
    prefix = optional(string, "")
    # exclusively for backward compatible HTTP endpoint
    uri = optional(string, "")
  })
  nullable    = false
  description = "Destination filedrop"
}

variable "forwarder" {
  description = <<-EOF
    Variables for forwarder module.
  EOF
  type = object({
    source_bucket_names                      = optional(list(string), [])
    source_object_keys                       = optional(list(string))
    source_topic_arns                        = optional(list(string), [])
    content_type_overrides                   = optional(list(object({ pattern = string, content_type = string })), [])
    max_file_size                            = optional(number)
    lambda_memory_size                       = optional(number)
    lambda_timeout                           = optional(number)
    lambda_env_vars                          = optional(map(string))
    lambda_runtime                           = optional(string)
    retention_in_days                        = optional(number)
    queue_max_receive_count                  = optional(number)
    queue_delay_seconds                      = optional(number)
    queue_message_retention_seconds          = optional(number)
    queue_batch_size                         = optional(number)
    queue_maximum_batching_window_in_seconds = optional(number)
    code_uri                                 = optional(string)
    sam_release_version                      = optional(string)
  })
  default  = {}
  nullable = false
}

variable "config" {
  description = <<-EOF
    Variables for AWS Config collection.
  EOF
  type = object({
    include_resource_types        = list(string)
    exclude_resource_types        = optional(list(string))
    delivery_frequency            = optional(string)
    include_global_resource_types = optional(bool)
    tag_account_alias             = optional(bool)
    aws_account_alias             = optional(string)
  })
  default = null
}

variable "configsubscription" {
  description = <<-EOF
    Variables for AWS Config subscription.
  EOF
  type = object({
    delivery_bucket_name = string
    tag_account_alias    = optional(bool)
    aws_account_alias    = optional(string)
  })
  default = null
}

variable "logwriter" {
  description = <<-EOF
    Variables for AWS CloudWatch Logs collection.
  EOF
  type = object({
    log_group_name_patterns         = optional(list(string))
    log_group_name_prefixes         = optional(list(string))
    exclude_log_group_name_prefixes = optional(list(string))
    buffering_interval              = optional(number)
    buffering_size                  = optional(number)
    filter_name                     = optional(string)
    filter_pattern                  = optional(string)
    num_workers                     = optional(number)
    discovery_rate                  = optional(string, "24 hours")
    lambda_memory_size              = optional(number)
    lambda_timeout                  = optional(number)
    lambda_env_vars                 = optional(map(string))
    lambda_runtime                  = optional(string)
    code_uri                        = optional(string)
    sam_release_version             = optional(string)
  })
  default = null
}

variable "metricstream" {
  description = <<-EOF
    Variables for AWS CloudWatch Metrics Stream collection.
  EOF
  type = object({
    include_filters     = optional(list(object({ namespace = string, metric_names = optional(list(string)) })))
    exclude_filters     = optional(list(object({ namespace = string, metric_names = optional(list(string)) })))
    buffering_interval  = optional(number)
    buffering_size      = optional(number)
    sam_release_version = optional(string)
  })
  default = null
}

variable "debug_endpoint" {
  description = "Endpoint to send debugging telemetry to. Sets OTEL_EXPORTER_OTLP_ENDPOINT environment variable for supported lambda functions."
  type        = string
  default     = null
}

variable "s3_bucket_lifecycle_expiration" {
  description = "Expiration in days for S3 objects in collection bucket"
  type        = number
  default     = 4
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

# Optional AWS Organizations ID. If set, we'll add an AllowAWSConfigFromOrg
# statement on the SNS topic that restricts publishes by aws:PrincipalOrgID.
variable "org_id" {
  description = "Optional AWS Organizations ID. If set, adds an AllowAWSConfigFromOrg statement on the SNS topic that allows publishes by aws:PrincipalOrgID. Useful for AWS Control Tower integrations."
  type        = string
  default     = null
}

# Optional list of AWS SourceAccount IDs. If non-empty, we'll add a
# statement that restricts publishes using the AWS:SourceAccount condition.
# The current (audit) account ID is automatically included in the list.
variable "source_accounts" {
  type        = list(string)
  default     = ["891377094505"]
  description = <<-EOF
    List of AWS account IDs allowed to publish to the SNS topic via AWS Config. Useful for sub-accounts in AWS Organizations and Control Tower integrations.
    The current account ID is automatically included when this list is non-empty.
  EOF
}
