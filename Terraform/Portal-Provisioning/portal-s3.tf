resource "aws_s3_bucket" "portal-s3-bucket" {
  bucket = var.client-asset-bucket
}

resource "aws_s3_bucket_cors_configuration" "portal-s3-bucket-cors" {
  bucket = aws_s3_bucket.portal-s3-bucket.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*.n4m.net"]
  }

    cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*${var.client-name}.net"]
  }

    cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*${var.client-name}.org"]
  }

    cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*${var.client-name}.com"]
  }

    cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*${var.addtional-cors}"]
  }
}


