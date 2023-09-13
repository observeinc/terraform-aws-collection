resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda_package.output_path
  function_name    = var.name
  role             = aws_iam_role.this.arn
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  handler          = "function.handler"
  runtime          = "python3.9"
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout

  environment {
    variables = merge({
      DESTINATION_URI = "s3://${var.destination.bucket}/${var.destination.prefix}"
    }, var.lambda_env_vars)
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = format("/aws/lambda/%s", var.name)
  retention_in_days = var.retention_in_days
}

/*
resource "aws_iam_role_policy_attachment" "write_bucket" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.write_bucket.arn
}

resource "aws_iam_policy" "sqs" {
  name_prefix = var.iam_name_prefix
  description = "IAM policy for receiving messages from SQS"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Resource": ${jsonencode(var.queue_arn)}
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sqs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.sqs.arn
}

resource "aws_iam_policy" "assume_role_external" {
  name_prefix = var.iam_name_prefix
  description = "IAM policy for assuming cross account role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${var.reader_role_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "assume_role_external" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.assume_role_external.arn
}

resource "aws_lambda_event_source_mapping" "queue" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.this.arn
  batch_size       = var.queue_batch_size
  depends_on       = [aws_iam_role_policy_attachment.sqs]
}
*/
