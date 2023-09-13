/*
data "aws_arn" "bucket" {
  count = length(var.bucket_arns)
  arn   = var.bucket_arns[count.index]
}

resource "aws_lambda_permission" "allow_bucket" {
  count         = length(data.aws_arn.bucket)
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_arn.bucket[count.index].arn
}

resource "aws_s3_bucket_notification" "notification" {
  count  = length(aws_lambda_permission.allow_bucket)
  bucket = data.aws_arn.bucket[count.index].resource
  lambda_function {
    lambda_function_arn = aws_lambda_permission.allow_bucket[count.index].function_name
    events              = ["s3:ObjectCreated:*"]
  }
}
*/
