# Setup subscriptions

We create up to 3 S3 buckets and subscribe them to a forwarder via different routes:

- S3 bucket notifications to SQS
- S3 bucket notifications to SNS to SQS
- Eventbridge

We return the buckets for testing whether objects are correctly copied from a source to destination bucket.
