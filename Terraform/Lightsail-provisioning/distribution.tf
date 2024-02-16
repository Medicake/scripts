resource "aws_cloudfront_distribution" "wordpress_cf_distribution" {
  origin {
    domain_name = "lightsail.${data.local_file.domain-name-file.content}"
    origin_id   = "${data.local_file.client-name-file.content}-lightsail"
    custom_header {
       name = "x-dantest" 
       value = "wordpress-cloudfront"
    }
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${data.local_file.client-name-file.content} CloudFront distribution"
  
#   aliases = ["www.${data.local_file.domain-name-file.content}", "${data.local_file.domain-name-file.content}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${data.local_file.client-name-file.content}-lightsail"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["Host","CloudFront-Forwarded-Proto","CloudFront-Is-Mobile-Viewer","CloudFront-Is-Tablet-Viewer","CloudFront-Is-Desktop-Viewer"]
    }

    viewer_protocol_policy      = "redirect-to-https"
    min_ttl                     = 0
    default_ttl                 = 3600
    max_ttl                     = 86400
    compress                    = true
  }

  # New behavior section for wp-admin/*
  ordered_cache_behavior {
    path_pattern     = "/wp-admin/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${data.local_file.client-name-file.content}-lightsail"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["*"]
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
  }

  # New behavior section for wp-content/*
  ordered_cache_behavior {
    path_pattern     = "/wp-content/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${data.local_file.client-name-file.content}-lightsail"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["US"]
    }
  }

  price_class = "PriceClass_100"

}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.wordpress_cf_distribution.domain_name}"
}

output "Make-sure-to-add-this-record"{
    value = "lightsail.${data.local_file.domain-name-file.content} = ${aws_lightsail_static_ip.lightsail-static.ip_address}"
}

