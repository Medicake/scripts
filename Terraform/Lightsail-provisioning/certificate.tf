resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name = "www.${data.local_file.domain-name-file.content}"
  subject_alternative_names = ["${data.local_file.domain-name-file.content}"] 
  validation_method = "DNS"
  
  tags = {
    Name = "${data.local_file.client-name-file.content}-cert"
  }
}

output "validation_options" {
  value = "${aws_acm_certificate.cloudfront_cert.domain_validation_options}"
}
