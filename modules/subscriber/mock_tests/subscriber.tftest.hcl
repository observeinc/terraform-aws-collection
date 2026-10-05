mock_provider "aws" {
  source = "../testing/aws_mock"
}

run "setup" {
  module {
    source = "../testing/setup"
  }
}

run "create_bucket" {
  module {
    source = "../testing/s3_bucket"
  }

  variables {
    setup = run.setup
  }
}

# Verify the subscriber module installs and exposes expected outputs
run "install_subscriber" {
  variables {
    name                    = run.setup.short
    code_uri                = "s3://mock-bucket/mock-key"
    bucket_arn              = run.create_bucket.arn
    destination_iam_arn     = "arn:aws:iam::123456789012:role/mock-destination-role"
    firehose_arn            = "arn:aws:firehose:us-east-1:123456789012:deliverystream/mock-stream"
    log_group_name_patterns = ["/test/${run.setup.short}"]
  }

  assert {
    condition     = output.function_arn != null
    error_message = "function_arn should be set"
  }
}

# Verify updating patterns works
run "update_subscriber" {
  variables {
    name                    = run.setup.short
    code_uri                = "s3://mock-bucket/mock-key"
    bucket_arn              = run.create_bucket.arn
    destination_iam_arn     = "arn:aws:iam::123456789012:role/mock-destination-role"
    firehose_arn            = "arn:aws:firehose:us-east-1:123456789012:deliverystream/mock-stream"
    log_group_name_patterns = ["/test/${run.setup.short}/other"]
  }
}
