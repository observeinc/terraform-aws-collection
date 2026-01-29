# Cleanup trigger for Terraform destroy
# This resource invokes the Lambda's cleanup function before the Lambda is destroyed
# to remove all subscription filters managed by this subscriber

resource "null_resource" "cleanup_on_destroy" {
  # Trigger cleanup whenever the Lambda configuration changes or on destroy
  triggers = {
    function_arn                    = aws_lambda_function.subscriber.arn
    queue_url                       = aws_sqs_queue.queue.id
    dlq_url                         = aws_sqs_queue.dead_letter.id
    lambda_timeout                  = tostring(var.lambda_timeout)
    firehose_arn                    = var.firehose_arn
    log_group_name_patterns         = join(",", var.log_group_name_patterns)
    log_group_name_prefixes         = join(",", var.log_group_name_prefixes)
    exclude_log_group_name_patterns = join(",", var.exclude_log_group_name_patterns)
    filter_name                     = var.filter_name
  }

  # On destroy, enqueue cleanup work and wait for queue drain before teardown.
  # This avoids a single long-running Lambda invoke timing out in larger environments.
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      set -euo pipefail

      REGION=$(echo ${self.triggers.function_arn} | cut -d: -f4)
      QUEUE_URL="${self.triggers.queue_url}"
      DLQ_URL="${self.triggers.dlq_url}"
      POLL_INTERVAL_SECONDS=5
      REQUIRED_STABLE_POLLS=3
      STAGNATION_SECONDS=$(( ${self.triggers.lambda_timeout} * 2 ))
      if [ "$STAGNATION_SECONDS" -lt 180 ]; then
        STAGNATION_SECONDS=180
      fi
      MAX_WAIT_SECONDS=1200

      get_queue_attr() {
        local queue_url="$1"
        local attribute_name="$2"
        local value
        value=$(
          aws sqs get-queue-attributes \
            --queue-url "$queue_url" \
            --region "$REGION" \
            --attribute-names "$attribute_name" \
            --query "Attributes.$attribute_name" \
            --output text \
            --no-cli-pager
        )
        if [ "$value" = "None" ] || [ -z "$value" ]; then
          echo 0
        else
          echo "$value"
        fi
      }

      start_dlq_messages=$(get_queue_attr "$DLQ_URL" "ApproximateNumberOfMessages")
      CLEANUP_JOB_ID="terraform-destroy-$(date +%s)"

      echo "Queueing cleanup request for ${self.triggers.function_arn} in region $REGION..." >&2
      aws sqs send-message \
        --queue-url "$QUEUE_URL" \
        --region "$REGION" \
        --message-body "{\"cleanup\":{\"dryRun\":false,\"deleteAll\":true,\"maxGroupsPerInvocation\":200,\"jobId\":\"$CLEANUP_JOB_ID\"}}" \
        --no-cli-pager > /dev/null

      stable_polls=0
      elapsed=0
      best_pending=-1
      last_decrease_elapsed=0
      while [ "$elapsed" -lt "$MAX_WAIT_SECONDS" ]; do
        visible=$(get_queue_attr "$QUEUE_URL" "ApproximateNumberOfMessages")
        not_visible=$(get_queue_attr "$QUEUE_URL" "ApproximateNumberOfMessagesNotVisible")
        dlq_visible=$(get_queue_attr "$DLQ_URL" "ApproximateNumberOfMessages")
        pending=$((visible + not_visible))

        echo "cleanup queue status: visible=$visible in_flight=$not_visible dlq_visible=$dlq_visible elapsed=$elapsed/$MAX_WAIT_SECONDS" >&2

        if [ "$best_pending" -lt 0 ] || [ "$pending" -lt "$best_pending" ]; then
          best_pending="$pending"
          last_decrease_elapsed="$elapsed"
        fi

        if [ "$visible" -eq 0 ] && [ "$not_visible" -eq 0 ]; then
          stable_polls=$((stable_polls + 1))
          if [ "$stable_polls" -ge "$REQUIRED_STABLE_POLLS" ]; then
            break
          fi
        else
          stable_polls=0
        fi

        if [ "$pending" -gt 0 ] && [ $((elapsed - last_decrease_elapsed)) -ge "$STAGNATION_SECONDS" ]; then
          echo "Cleanup made no progress for $STAGNATION_SECONDS seconds (pending=$pending, best_pending=$best_pending)." >&2
          exit 1
        fi

        sleep "$POLL_INTERVAL_SECONDS"
        elapsed=$((elapsed + POLL_INTERVAL_SECONDS))
      done

      if [ "$stable_polls" -lt "$REQUIRED_STABLE_POLLS" ]; then
        echo "Cleanup did not complete within $MAX_WAIT_SECONDS seconds." >&2
        exit 1
      fi

      end_dlq_messages=$(get_queue_attr "$DLQ_URL" "ApproximateNumberOfMessages")
      if [ "$end_dlq_messages" -gt "$start_dlq_messages" ]; then
        echo "Cleanup pushed messages to DLQ (before=$start_dlq_messages after=$end_dlq_messages)." >&2
        exit 1
      fi
    EOT
  }

  # On create/update (when triggers change), enqueue discovery on SQS and wait
  # for processing. The subscriber expects SQS-wrapped requests; direct invoke
  # payloads can be ignored by the handler.
  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail

      REGION=$(echo ${self.triggers.function_arn} | cut -d: -f4)
      QUEUE_URL="${self.triggers.queue_url}"
      DLQ_URL="${self.triggers.dlq_url}"
      POLL_INTERVAL_SECONDS=5
      REQUIRED_STABLE_POLLS=3
      MAX_WAIT_SECONDS=1200

      get_queue_attr() {
        local queue_url="$1"
        local attribute_name="$2"
        local value
        value=$(
          aws sqs get-queue-attributes \
            --queue-url "$queue_url" \
            --region "$REGION" \
            --attribute-names "$attribute_name" \
            --query "Attributes.$attribute_name" \
            --output text \
            --no-cli-pager
        )
        if [ "$value" = "None" ] || [ -z "$value" ]; then
          echo 0
        else
          echo "$value"
        fi
      }

      start_dlq_messages=$(get_queue_attr "$DLQ_URL" "ApproximateNumberOfMessages")
      DISCOVERY_JOB_ID="terraform-apply-$(date +%s)"

      echo "Queueing discovery request for ${self.triggers.function_arn} in region $REGION..." >&2
      aws sqs send-message \
        --queue-url "$QUEUE_URL" \
        --region "$REGION" \
        --message-body "{\"discover\":{\"logGroupNamePatterns\":${jsonencode(var.log_group_name_patterns)},\"logGroupNamePrefixes\":${jsonencode(var.log_group_name_prefixes)},\"excludeLogGroupNamePatterns\":${jsonencode(var.exclude_log_group_name_patterns)},\"inline\":true,\"maxGroupsPerInvocation\":200,\"jobId\":\"$DISCOVERY_JOB_ID\"}}" \
        --no-cli-pager > /dev/null

      stable_polls=0
      elapsed=0
      while [ "$elapsed" -lt "$MAX_WAIT_SECONDS" ]; do
        visible=$(get_queue_attr "$QUEUE_URL" "ApproximateNumberOfMessages")
        not_visible=$(get_queue_attr "$QUEUE_URL" "ApproximateNumberOfMessagesNotVisible")
        dlq_visible=$(get_queue_attr "$DLQ_URL" "ApproximateNumberOfMessages")

        echo "discovery queue status: visible=$visible in_flight=$not_visible dlq_visible=$dlq_visible elapsed=$elapsed/$MAX_WAIT_SECONDS" >&2

        if [ "$visible" -eq 0 ] && [ "$not_visible" -eq 0 ]; then
          stable_polls=$((stable_polls + 1))
          if [ "$stable_polls" -ge "$REQUIRED_STABLE_POLLS" ]; then
            break
          fi
        else
          stable_polls=0
        fi

        sleep "$POLL_INTERVAL_SECONDS"
        elapsed=$((elapsed + POLL_INTERVAL_SECONDS))
      done

      if [ "$stable_polls" -lt "$REQUIRED_STABLE_POLLS" ]; then
        echo "Discovery did not complete within $MAX_WAIT_SECONDS seconds." >&2
        exit 1
      fi

      end_dlq_messages=$(get_queue_attr "$DLQ_URL" "ApproximateNumberOfMessages")
      if [ "$end_dlq_messages" -gt "$start_dlq_messages" ]; then
        echo "Discovery pushed messages to DLQ (before=$start_dlq_messages after=$end_dlq_messages)." >&2
        exit 1
      fi
    EOT
  }

  depends_on = [
    aws_lambda_function.subscriber,
    aws_lambda_event_source_mapping.subscriber_sqs,
    aws_sqs_queue.queue,
    aws_sqs_queue.dead_letter,
    aws_sqs_queue_policy.queue_policy,
  ]
}

