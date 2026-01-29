# Cleanup trigger for Terraform destroy
# This resource invokes the Lambda's cleanup function before the Lambda is destroyed
# to remove all subscription filters managed by this subscriber

resource "null_resource" "cleanup_on_destroy" {
  # Trigger cleanup whenever the Lambda configuration changes or on destroy
  triggers = {
    function_arn                    = aws_lambda_function.subscriber.arn
    firehose_arn                    = var.firehose_arn
    log_group_name_patterns         = join(",", var.log_group_name_patterns)
    log_group_name_prefixes         = join(",", var.log_group_name_prefixes)
    exclude_log_group_name_patterns = join(",", var.exclude_log_group_name_patterns)
    filter_name                     = var.filter_name
  }

  # On destroy, invoke the Lambda to clean up subscriptions
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      RESPONSE_FILE="/tmp/cleanup-response-$${RANDOM}.json"
      REGION=$(echo ${self.triggers.function_arn} | cut -d: -f4)
      echo "Invoking cleanup on ${self.triggers.function_arn} in region $REGION..." >&2

      if aws lambda invoke \
        --function-name ${self.triggers.function_arn} \
        --region "$REGION" \
        --cli-binary-format raw-in-base64-out \
        --payload '{"cleanup":{"dryRun":false,"deleteAll":true}}' \
        "$RESPONSE_FILE" \
        --no-cli-pager 2>&1; then
        echo "Cleanup invoked successfully" >&2
        cat "$RESPONSE_FILE" >&2
      else
        echo "Warning: Failed to invoke cleanup Lambda (may already be deleted)" >&2
      fi
    EOT
  }

  # On update (when triggers change), invoke discovery with new patterns
  # This reconciles subscriptions when patterns are updated
  provisioner "local-exec" {
    command = <<-EOT
      REGION=$(echo ${aws_lambda_function.subscriber.arn} | cut -d: -f4)
      aws lambda invoke \
        --function-name ${aws_lambda_function.subscriber.arn} \
        --region "$REGION" \
        --cli-binary-format raw-in-base64-out \
        --payload '{"discover":{"logGroupNamePatterns":${jsonencode(var.log_group_name_patterns)},"logGroupNamePrefixes":${jsonencode(var.log_group_name_prefixes)},"excludeLogGroupNamePatterns":${jsonencode(var.exclude_log_group_name_patterns)},"inline":true}}' \
        /tmp/discovery-response-$${RANDOM}.json \
        --no-cli-pager \
        > /dev/null 2>&1 || echo "Warning: Failed to invoke discovery Lambda"
    EOT
  }

  depends_on = [
    aws_lambda_function.subscriber,
    aws_lambda_event_source_mapping.subscriber_sqs
  ]
}

