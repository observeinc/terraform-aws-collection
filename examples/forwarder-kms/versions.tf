terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }

    observe = {
      source  = "terraform.observeinc.com/observeinc/observe"
      version = "~> 0.14"
    }
  }
}
