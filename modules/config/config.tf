resource "aws_config_configuration_recorder" "this" {
  name     = var.name
  role_arn = aws_iam_role.this.arn

  recording_group {
    all_supported                 = local.all_supported
    include_global_resource_types = local.all_supported && var.include_global_resource_types

    dynamic "exclusion_by_resource_types" {
      for_each = length(var.exclude_resource_types) > 0 ? [1] : []
      content {
        resource_types = var.exclude_resource_types
      }
    }

    resource_types = local.include_resource_types

    recording_strategy {
      use_only = length(local.include_resource_types) > 0 ? "INCLUSION_BY_RESOURCE_TYPES" : (
        length(var.exclude_resource_types) > 0 ? "EXCLUSION_BY_RESOURCE_TYPES" : "ALL_SUPPORTED_RESOURCE_TYPES"
      )
    }
  }

  lifecycle {
    precondition {
      condition     = length(var.exclude_resource_types) == 0 || contains(var.include_resource_types, "*")
      error_message = "exclude_resource_types requires wildcarding include_resource_types."
    }
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = var.name
  s3_bucket_name = var.bucket
  s3_key_prefix  = var.prefix
  sns_topic_arn  = var.sns_topic_arn

  snapshot_delivery_properties {
    delivery_frequency = var.delivery_frequency
  }

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}
