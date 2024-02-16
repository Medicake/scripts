resource "aws_cloudfront_distribution" "portal_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.portal-s3-bucket.bucket_regional_domain_name
    origin_id = "S3-${var.client-asset-bucket}"
  }
  enabled = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = "S3-${var.client-asset-bucket}"
    viewer_protocol_policy = "allow-all"
    # We use these values to trigger AWS to "Use Origin headers for cache"
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
    forwarded_values {
      headers = [ "origin" ]
      query_string = "false"
      cookies {
        forward = "none"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }


}