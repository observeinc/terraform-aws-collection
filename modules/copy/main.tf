locals {
  read_any = contains(var.bucket_arns, "*")
  policies = {
    logging = data.aws_iam_policy_document.logging.json
    writer  = data.aws_iam_policy_document.writer.json
    reader  = data.aws_iam_policy_document.reader.json
  }
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/code/function.py"
  output_path = "index.zip"
}


