mock_provider "aws" {
  source = "../testing/aws_mock"
}

run "setup" {
  module {
    source = "../testing/setup"
  }

  variables {
    id_length = 50
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
    name = run.setup.id
    destination = {
      arn    = run.create_bucket.access_point.arn
      bucket = run.create_bucket.access_point.alias
      prefix = ""
    }

    forwarder = {
      code_uri = "s3://mock-bucket/mock-key"
    }

    configsubscription = {
      delivery_bucket_name = run.create_bucket.access_point.bucket
    }

    config = {
      include_resource_types = ["*"]
    }

    logwriter = {
      log_group_name_patterns         = ["*"]
      exclude_log_group_name_patterns = ["^/aws/elasticbeanstalk"]
      lambda_timeout                  = 600
      code_uri                        = "s3://mock-bucket/mock-key"
      # Disable provisioners that require the AWS CLI on the Terraform runner
      wait_for_discovery_on_apply = false
      cleanup_on_destroy          = false
    }

    metricstream = {
      include_filters = [
        {
          namespace = "AWS/RDS"
        }
      ]
    }
  }
}
