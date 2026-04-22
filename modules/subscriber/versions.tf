terraform {
  required_version = ">= 1.9.8"
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
