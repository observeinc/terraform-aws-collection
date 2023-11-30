resource "aws_scheduler_schedule" "discovery" {
  name_prefix = local.name_prefix

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(${var.discovery_rate})"

  target {
    arn      = aws_sqs_queue.this.arn
    role_arn = aws_iam_role.scheduler.arn

    input = jsonencode({
      discover = {
        logGroupNamePrefixes = var.log_group_name_prefixes
        logGroupNamePatterns = var.log_group_name_patterns
      }
    })
  }
}
