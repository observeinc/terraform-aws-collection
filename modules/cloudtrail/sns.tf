resource "aws_sns_topic" "this" {
  name_prefix = local.name_prefix
}

data "aws_iam_policy_document" "s3_to_sns" {
  statement {
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.this.arn]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_sns_topic_policy" "s3_to_sns" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.s3_to_sns.json
}

resource "aws_s3_bucket_notification" "this" {
  bucket = aws_s3_bucket.this.id
  topic {
    topic_arn = aws_sns_topic.this.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sns_topic_policy.s3_to_sns]
}
