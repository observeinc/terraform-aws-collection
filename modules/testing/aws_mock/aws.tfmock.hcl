mock_data "aws_caller_identity" {
  defaults = {
    account_id = "123456789012"
    arn        = "arn:aws:iam::123456789012:user/mock"
    user_id    = "AIDAIOSFODNN7EXAMPLE"
  }
}

mock_data "aws_region" {
  defaults = {
    name        = "us-east-1"
    region      = "us-east-1"
    description = "US East (N. Virginia)"
    id          = "us-east-1"
  }
}

mock_data "aws_partition" {
  defaults = {
    partition  = "aws"
    dns_suffix = "amazonaws.com"
    id         = "aws"
  }
}

# Used by modules/config for the managed Config service role
mock_data "aws_iam_policy" {
  defaults = {
    arn    = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
    id     = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
    name   = "AWS_ConfigRole"
    path   = "/service-role/"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

mock_data "aws_iam_account_alias" {
  defaults = {
    account_alias = "mock-account"
  }
}

# aws_iam_role validates that assume_role_policy is valid JSON.
# Provide a minimal valid policy so mocked aws_iam_role resources don't fail
# the client-side JSON check.
mock_data "aws_iam_policy_document" {
  defaults = {
    json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

# Resources whose .arn is passed to other resources' ARN-validated attributes
# (e.g. aws_lambda_function.role, aws_cloudwatch_event_target.arn) must have
# properly formatted ARNs — the AWS provider validates these client-side even
# during mock apply.

mock_resource "aws_iam_role" {
  defaults = {
    arn       = "arn:aws:iam::123456789012:role/mock-role"
    unique_id = "AIDAIOSFODNN7EXAMPLE"
  }
}

mock_resource "aws_sqs_queue" {
  defaults = {
    arn = "arn:aws:sqs:us-east-1:123456789012:mock-queue"
    id  = "https://sqs.us-east-1.amazonaws.com/123456789012/mock-queue"
    url = "https://sqs.us-east-1.amazonaws.com/123456789012/mock-queue"
  }
}

mock_resource "aws_lambda_function" {
  defaults = {
    arn           = "arn:aws:lambda:us-east-1:123456789012:function:mock-function"
    qualified_arn = "arn:aws:lambda:us-east-1:123456789012:function:mock-function:$LATEST"
    invoke_arn    = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:mock-function/invocations"
  }
}

mock_resource "aws_cloudwatch_log_group" {
  defaults = {
    arn = "arn:aws:logs:us-east-1:123456789012:log-group:mock-log-group"
  }
}

mock_resource "aws_kinesis_firehose_delivery_stream" {
  defaults = {
    arn = "arn:aws:firehose:us-east-1:123456789012:deliverystream/mock-stream"
  }
}

mock_resource "aws_sns_topic" {
  defaults = {
    arn = "arn:aws:sns:us-east-1:123456789012:mock-topic"
  }
}

mock_resource "aws_s3_bucket" {
  defaults = {
    arn    = "arn:aws:s3:::mock-bucket"
    bucket = "mock-bucket"
    id     = "mock-bucket"
  }
}

mock_resource "aws_s3_access_point" {
  defaults = {
    arn    = "arn:aws:s3:us-east-1:123456789012:accesspoint/mock-access-point"
    alias  = "mock-access-point-123456789012-s3alias"
    bucket = "mock-bucket"
  }
}

mock_resource "aws_kms_key" {
  defaults = {
    arn    = "arn:aws:kms:us-east-1:123456789012:key/mock-key-id"
    key_id = "mock-key-id"
  }
}

mock_resource "aws_iam_policy" {
  defaults = {
    arn = "arn:aws:iam::123456789012:policy/mock-policy"
    id  = "arn:aws:iam::123456789012:policy/mock-policy"
  }
}

mock_resource "aws_cloudwatch_event_rule" {
  defaults = {
    arn = "arn:aws:events:us-east-1:123456789012:rule/mock-rule"
  }
}
