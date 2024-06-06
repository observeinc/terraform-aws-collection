terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}
