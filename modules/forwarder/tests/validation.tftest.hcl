
# The below variables are all valid. We will validate them in first test, and
# then successively override them with bad inputs.
variables {
  name = "test"
  destination = {
    bucket = "bucket-name"
  }
  source_bucket_names = ["*", "a-b-c-", "a31asf"]
  source_topic_arns   = ["arn:aws:sns:us-west-2:123456789012:my-topic-name"]
  source_kms_key_arns = ["arn:aws:kms:us-west-2:123456789012:key/abcd1234-ab12-cd34-ef56-abcdef123456"]

  content_type_overrides = [
    {
      pattern      = ".*"
      content_type = "application/json"
    }
  ]
}

run "valid_canned_variables" {
  command = plan
}

run "invalid_uri_scheme" {
  command         = plan
  expect_failures = [var.destination]

  variables {
    destination = {
      uri = "ftp://foo"
    }
  }
}

run "mutually_exclusive_uri_and_bucket" {
  command         = plan
  expect_failures = [var.destination]

  variables {
    destination = {
      uri    = "https://foo.com"
      bucket = "foo.com"
    }
  }
}

run "invalid_source_bucket_name" {
  command         = plan
  expect_failures = [var.source_bucket_names]

  variables {
    source_bucket_names = ["a*c"]
  }
}

run "source_bucket_arn" {
  command         = plan
  expect_failures = [var.source_bucket_names]

  variables {
    source_bucket_names = ["arn:s3:::hello-world"]
  }
}

run "invalid_source_topic_arn" {
  command         = plan
  expect_failures = [var.source_topic_arns]

  variables {
    source_topic_arns = ["foo"]
  }
}

run "invalid_source_kms_key_arn" {
  command         = plan
  expect_failures = [var.source_kms_key_arns]

  variables {
    source_kms_key_arns = ["foo"]
  }
}

run "invalid_destination_bucket" {
  command         = plan
  expect_failures = [var.destination]

  variables {
    destination = {
      bucket = "s3://foo"
    }
  }
}
