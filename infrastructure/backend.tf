terraform {
  backend "s3" {
    bucket = "observeinc-terraform-state"
    region = "us-west-2"
    key    = "github.com/observeinc/terraform-aws-collection"
  }
}
