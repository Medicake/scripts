# Creating the actual lambda function

# Will need to rebuild the s3 section to upload 
# the function to the bucket instead of it already being there
resource "aws_lambda_function" "lambda-webp-function" {
  s3_bucket = "${var.lambda-code-bucket}"
  s3_key= "${var.lambda-function-zip}"
  function_name = "${var.client-name}-webp-resize-function"
  role = "${aws_iam_role.lambda-webp-role.arn}"
  handler = "index.handler"
  runtime = "nodejs14.x"
  memory_size = "2000"
  timeout = "900"
  environment {
    variables ={
        BUCKET = "${var.client-asset-bucket}"
    }
  }
}

resource "aws_lambda_permission" "lambda-web-invoke-permission" {
  statement_id = "AllowExecutionsFrom${var.client-asset-bucket}"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-webp-function.arn
  principal = "s3.amazonaws.com"
  source_account = var.aws-account-id
  source_arn = "arn:aws:s3:::${var.client-asset-bucket}"
}

resource "aws_s3_bucket_notification" "lambda-webp-trigger" {
  bucket = "${var.client-asset-bucket}"
  
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda-webp-function.arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "Assets/image/"
  }
}