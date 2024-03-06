mock_provider "observe" {
  source = "../../modules/testing/observe_mock"
}

# only verifies module can be installed and removed correctly
run "install" {}
