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

run "install" {
  variables {
    name       = run.setup.id
    bucket_arn = run.create_bucket.arn
  }
}

run "update_filters" {
  variables {
    name       = run.setup.id
    bucket_arn = run.create_bucket.arn
    include_filters = [
      {
        namespace    = "AWS/RDS"
        metric_names = []
      },
      {
        namespace = "AWS/EC2"
        metric_names = [
          "DiskWriteBytes",
        ]
      },
    ]
  }
}

run "enable_tag_enrichment" {
  variables {
    name                  = run.setup.id
    bucket_arn            = run.create_bucket.arn
    enable_tag_enrichment = true
    sam_release_version   = "2.13.0"
  }

  assert {
    condition     = length(aws_lambda_function.metrictag) == 1
    error_message = "metrictag Lambda should be created when tag enrichment is enabled"
  }

  assert {
    condition     = one(aws_kinesis_firehose_delivery_stream.this.extended_s3_configuration[*].processing_configuration[0].enabled) == true
    error_message = "Firehose processing configuration should be enabled when tag enrichment is enabled"
  }
}
