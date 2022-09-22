variable "name" {
    type = string
}

variable "role_arn" {
    type = string
}


resource "aws_lambda_function" "lambda_function" {
  filename      = "lambda_function_payload.zip"
  function_name = var.name
  role          = var.role_arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs12.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}