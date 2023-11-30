resource "random_pet" "run" {
  length = 2
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  bucket        = random_pet.run.id
  force_destroy = true
}

resource "aws_s3_access_point" "this" {
  bucket = aws_s3_bucket.this.id
  name   = random_pet.run.id
}
