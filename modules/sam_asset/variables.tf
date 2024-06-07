variable "asset" {
  description = <<-EOF
    Asset key. This value is appended to the SAM apps version prefix to form
    the object key.
  EOF
  type        = string
  nullable    = false
}

variable "release_version" {
  description = "Release version on github.com/observeinc/aws-sam-apps."
  type        = string
  default     = ""
  nullable    = false
}
