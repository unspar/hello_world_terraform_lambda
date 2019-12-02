# Simple AWS Lambda Terraform Example
# requires 'lambda_function.py' in the same directory
# to test: run `terraform plan`
# to deploy: run `terraform apply`

variable "aws_region" {
  default = "us-east-2"
}

provider "aws" {
  region          = "${var.aws_region}"
}

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "lambda_function.py"
    output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "test_lambda"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "python3.7"
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
