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
