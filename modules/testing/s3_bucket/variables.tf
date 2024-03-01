variable "setup" {
  type = object({
    short = string
  })
  description = "Setup module."
}

variable "enable_access_point" {
  description = "Enable access point on S3 bucket"
  type        = bool
  default     = true
  nullable    = false
}

variable "kms_key_policy_json" {
  description = "JSON encoded KMS key policy. If set, the S3 bucket will be encrypted using a KMS key."
  type        = string
  default     = ""
  nullable    = false
}
