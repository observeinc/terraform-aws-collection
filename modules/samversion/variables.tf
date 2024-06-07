variable "app" {
  description = "App name"
  type        = string
  nullable    = false
}

variable "function" {
  description = "Function name"
  type        = string
  default     = ""
  nullable    = false
}

variable "release" {
  description = "Release version on github.com/observeinc/aws-sam-apps."
  type        = string
  default     = ""
  nullable    = false
}
