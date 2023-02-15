terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.75"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }

    # TODO(luke): uncomment this in a follow up commit to make terraform-aws-collection
    # more likely to avoid the terraform apply failure
    # (due to s3 bucket notification eventual consistency)
    # time = {
    #   source  = "hashicorp/time"
    #   version = ">= 0.9.1"
    # }
  }
}
