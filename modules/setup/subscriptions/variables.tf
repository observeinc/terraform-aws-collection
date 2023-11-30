variable "run_id" {
  description = "Run identifier"
  type        = string
}

variable "sources" {
  description = "Source of S3 event notification"
  type        = set(string)
  default     = ["sns", "sqs", "eventbridge"]
}

variable "queue_arn" {
  description = "Queue to trigger with S3 event notification"
  type        = string
  default     = null
}

variable "sleep_interval" {
  description = <<-EOF
    Interval to wait before returning. This allows subscriptions to be
    picked up.
  EOF
  type        = string
  default     = "0s"
}
