resource "aws_scheduler_schedule" "discovery_schedule" {
  count       = local.has_discovery_rate ? 1 : 0
  name        = "DiscoverySchedule"
  description = "Trigger log group discovery"
  state       = "ENABLED"
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(${var.discovery_rate})"

  target {
    arn      = aws_sqs_queue.queue.arn
    role_arn = aws_iam_role.scheduler.arn
    input = jsonencode({
      discover = {
        logGroupNamePatterns = var.log_group_name_patterns
        logGroupNamePrefixes = var.log_group_name_prefixes
      }
    })
  }
}