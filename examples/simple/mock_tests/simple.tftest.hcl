mock_provider "aws" {
  source = "../../modules/testing/aws_mock"
}

run "install" {
  variables {
    observe_customer = "1"
    observe_token    = "dskey:secret"
  }
}
