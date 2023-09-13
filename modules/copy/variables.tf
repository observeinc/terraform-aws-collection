variable "name" {
  type        = string
  description = <<-EOF
    Name of role. Since this name must be unique within the
    account, it will be reused for most of the resources created by this
    module.
  EOF
}

variable "destination" {
  type = object({
    arn    = string
    bucket = string
    prefix = string
  })
  description = "Destination filedrop"
}

variable "bucket_arns" {
  type        = list(string)
  description = "ARNs for buckets to copy files from"
}

variable "lambda_memory_size" {
  description = "Memory size for lambda function."
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout in seconds for lambda function."
  type        = number
  default     = 60
}

variable "lambda_env_vars" {
  description = "Environment variables to be passed into lambda."
  type        = map(string)
  default     = {}
}

variable "retention_in_days" {
  description = "Retention in days of cloudwatch log group"
  type        = number
  default     = 365
}
