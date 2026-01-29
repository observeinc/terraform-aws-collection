# Subscription lifecycle via local-exec + SQS:
# - subscriber_destroy_cleanup: destroy-time only (infra triggers). Queues delete-all cleanup
#   before Lambda/queues are torn down. Does not replace when log group patterns change.
# - discovery_on_apply: apply-time only (pattern / destination triggers). Queues fullyPrune
#   discovery when config changes. No destroy provisioner, so pattern updates do not run
#   delete-all cleanup during null_resource replacement.
#
# discovery_on_apply depends_on cleanup_on_destroy so create order is: cleanup_on_destroy
# (noop on create) then discovery. On upgrade from the pre-split single null_resource,
# replacement of cleanup_on_destroy runs the destroy provisioner before discovery_on_apply is created.

resource "null_resource" "cleanup_on_destroy" {
  triggers = {
    function_arn       = aws_lambda_function.subscriber.arn
    queue_url          = aws_sqs_queue.queue.id
    dlq_url            = aws_sqs_queue.dead_letter.id
    lambda_timeout     = tostring(var.lambda_timeout)
    cleanup_on_destroy = tostring(var.cleanup_on_destroy)
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      set -euo pipefail

      if [ "${lookup(self.triggers, "cleanup_on_destroy", "true")}" != "true" ]; then
        echo "Skipping cleanup during destroy (cleanup_on_destroy=false)." >&2
        exit 0
      fi

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
      CLEANUP_PAYLOAD=$(printf '{"cleanup":{"dryRun":false,"deleteAll":true,"maxGroupsPerInvocation":200,"jobId":"%s"}}' "$CLEANUP_JOB_ID")

      echo "Queueing cleanup request for ${self.triggers.function_arn} in region $REGION..." >&2
      aws sqs send-message \
        --queue-url "$QUEUE_URL" \
        --region "$REGION" \
        --message-body "$CLEANUP_PAYLOAD" \
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

  depends_on = [
    aws_lambda_function.subscriber,
    aws_lambda_event_source_mapping.subscriber_sqs,
    aws_sqs_queue.queue,
    aws_sqs_queue.dead_letter,
    aws_sqs_queue_policy.queue_policy,
  ]
}

resource "null_resource" "discovery_on_apply" {
  triggers = {
    function_arn                    = aws_lambda_function.subscriber.arn
    queue_url                       = aws_sqs_queue.queue.id
    dlq_url                         = aws_sqs_queue.dead_letter.id
    lambda_timeout                  = tostring(var.lambda_timeout)
    wait_for_discovery_on_apply     = tostring(var.wait_for_discovery_on_apply)
    log_group_name_patterns         = join(",", var.log_group_name_patterns)
    log_group_name_prefixes         = join(",", var.log_group_name_prefixes)
    exclude_log_group_name_patterns = join(",", var.exclude_log_group_name_patterns)
    filter_name                     = var.filter_name
    filter_pattern                  = var.filter_pattern
    firehose_arn                    = var.firehose_arn
    destination_iam_arn             = var.destination_iam_arn
  }

  provisioner "local-exec" {
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
      DISCOVERY_JOB_ID="terraform-apply-$(date +%s)"
      DISCOVERY_PAYLOAD=$(printf '{"discover":{"logGroupNamePatterns":%s,"logGroupNamePrefixes":%s,"excludeLogGroupNamePatterns":%s,"fullyPrune":true,"inline":true,"maxGroupsPerInvocation":200,"jobId":"%s"}}' \
        '${jsonencode(var.log_group_name_patterns)}' \
        '${jsonencode(var.log_group_name_prefixes)}' \
        '${jsonencode(var.exclude_log_group_name_patterns)}' \
        "$DISCOVERY_JOB_ID")

      echo "Queueing discovery request for ${self.triggers.function_arn} in region $REGION..." >&2
      aws sqs send-message \
        --queue-url "$QUEUE_URL" \
        --region "$REGION" \
        --message-body "$DISCOVERY_PAYLOAD" \
        --no-cli-pager > /dev/null

      if [ "${var.wait_for_discovery_on_apply}" != "true" ]; then
        echo "Skipping discovery queue wait during apply (wait_for_discovery_on_apply=false)." >&2
        exit 0
      fi

      stable_polls=0
      elapsed=0
      best_pending=-1
      last_decrease_elapsed=0
      while [ "$elapsed" -lt "$MAX_WAIT_SECONDS" ]; do
        visible=$(get_queue_attr "$QUEUE_URL" "ApproximateNumberOfMessages")
        not_visible=$(get_queue_attr "$QUEUE_URL" "ApproximateNumberOfMessagesNotVisible")
        dlq_visible=$(get_queue_attr "$DLQ_URL" "ApproximateNumberOfMessages")
        pending=$((visible + not_visible))

        echo "discovery queue status: visible=$visible in_flight=$not_visible dlq_visible=$dlq_visible elapsed=$elapsed/$MAX_WAIT_SECONDS" >&2

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
          echo "Discovery made no progress for $STAGNATION_SECONDS seconds (pending=$pending, best_pending=$best_pending)." >&2
          exit 1
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
    null_resource.cleanup_on_destroy,
  ]
}
