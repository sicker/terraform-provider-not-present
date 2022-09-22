terraform {
  required_version = "0.12.31"
  #required_version = "0.13.5"

  required_providers {
    aws        = "2.52.0"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_lambda_function" "lambda_function" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs12.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_iam_role" "lambda_role2" {
  name               = "iam_for_lambda_backup"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

module "lambda" {
  source = "../modules/lambda"

  name = "lambda_function_name2"
  role_arn = aws_iam_role.lambda_role2.arn
}
