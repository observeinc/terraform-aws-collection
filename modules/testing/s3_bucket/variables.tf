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
