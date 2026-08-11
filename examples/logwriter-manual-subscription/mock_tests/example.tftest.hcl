mock_provider "aws" {
  source = "../../modules/testing/aws_mock"
}

mock_provider "http" {
  source = "../../modules/testing/http_mock"
}

# only verifies module can be installed and removed correctly
run "install" {}
