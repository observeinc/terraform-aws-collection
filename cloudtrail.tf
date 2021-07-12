resource "aws_cloudtrail" "trail" {
  name           = var.name
  s3_bucket_name = aws_s3_bucket.bucket.id
  s3_key_prefix  = var.s3_exported_prefix

  is_multi_region_trail = var.cloudtrail_is_multi_region_trail
  depends_on            = [aws_s3_bucket_policy.allow_cloudtrail]
}

resource "aws_s3_bucket_policy" "allow_cloudtrail" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "AWSCloudTrailAclCheck",
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Action": "s3:GetBucketAcl",
              "Resource": "${aws_s3_bucket.bucket.arn}"
          },
          {
              "Sid": "AWSCloudTrailWrite",
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Action": "s3:PutObject",
              "Resource": "${aws_s3_bucket.bucket.arn}/${var.s3_exported_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
              "Condition": {
                  "StringEquals": {
                      "s3:x-amz-acl": "bucket-owner-full-control"
                  }
              }
          }
      ]
  }
EOF
}
