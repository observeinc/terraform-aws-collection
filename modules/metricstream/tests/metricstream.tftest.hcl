run "setup" {
  module {
    source = "../testing/run"
  }
}

run "install" {
  variables {
    name       = run.setup.id
    bucket_arn = run.setup.bucket_arn
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
