run "default_include_all" {
  command = plan
  variables {
    name   = "some-test"
    bucket = "my-example-test"
  }
}

run "test_mutually_exclusive_args" {
  command = plan
  variables {
    name   = "some-test"
    bucket = "my-example-test"

    include_resource_types = ["AWS::EC2::Hohoho"]
    exclude_resource_types = ["AWS::EC2::Instance"]
  }

  expect_failures = [
    aws_config_configuration_recorder.this
  ]
}
