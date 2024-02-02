variable "name" {
  type        = string
  description = <<-EOF
    Name of role. Since this name must be unique within the
    account, it will be reused for most of the resources created by this
    module.
  EOF

  validation {
    condition     = length(var.name) <= 52
    error_message = "Name must be under 52 characters."
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

variable "content_type_overrides" {
  description = <<-EOF
      A list of key value pairs. The key is a regular expression which is
      applied to the S3 URI of forwarded files. The value is the content type
      to set for matching files. For example, `\.json$=application/x-ndjson`
      would forward all files ending in `.json` as newline delimited JSON
      files.
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

variable "include_resource_types" {
  description = <<-EOF
    Resources to collect using AWS Config. Use a wildcard to collect all
    supported resource types. Do not set this parameter if AWS Config is
    already installed for this region.
  EOF
  type        = list(string)
  nullable    = true
  default     = null
}

variable "exclude_resource_types" {
  description = <<-EOF
    Exclude a subset of resource types from configuration collection. This
    parameter can only be set if include_resource_types is wildcarded.
  EOF
  type        = list(string)
  nullable    = true
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

variable "forwarder_variables" {
  description = <<-EOF
    Overrides for forwarder module.
  EOF
  type        = any
  nullable    = false
  default     = {}
}

variable "config_variables" {
  description = <<-EOF
    Overrides for config module.
  EOF
  type        = any
  nullable    = false
  default     = {}
}

variable "logwriter_variables" {
  description = <<-EOF
    Overrides for logwriter module.
  EOF
  type        = any
  nullable    = false
  default     = {}
}
