resource "aws_iam_user" "smtp_user" {
  name = "${data.local_file.client-name-file.content}-ses-smtp-user"
}

resource "aws_iam_access_key" "smtp_user" {
  user = aws_iam_user.smtp_user.name
}

resource "aws_iam_user_policy" "ses_policy" {
  name   = "ses_policy"
  user   = aws_iam_user.smtp_user.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ses:SendRawEmail",
          "ses:SendEmail"
        ],
        Effect = "Allow",
        Resource = [
        "arn:aws:ses:us-east-1:awsaccid:identity/${data.local_file.domain-name-file.content}",
        "arn:aws:ses:us-east-1:awsaccid:configuration-set/${data.local_file.client-name-file.content}"
        ]
        Condition: {
                "StringEquals": {
                    "ses:FromAddress": "noreply@${data.local_file.domain-name-file.content}"
      }
     }
    } 
    ]
  })
}

resource "aws_sesv2_configuration_set" "ses-configset" {
  configuration_set_name = "${data.local_file.client-name-file.content}"
  reputation_options {
    reputation_metrics_enabled = false
  }
}

resource "aws_sesv2_email_identity" "client-ses-domain-identity" {
  email_identity = "${data.local_file.domain-name-file.content}"
  configuration_set_name = aws_sesv2_configuration_set.ses-configset.configuration_set_name
  dkim_signing_attributes {
    next_signing_key_length = "RSA_2048_BIT"
  }
}


output "smtp_username" {
  value = aws_iam_access_key.smtp_user.id
}

output "smtp_password" {
  value = aws_iam_access_key.smtp_user.ses_smtp_password_v4
  sensitive = true
}

# output "ses_domain_records" {
#   value = "${aws_sesv2_email_identity.client-ses-domain-identity.dkim_signing_attributes[0].tokens}"
# }

# output "ses_domain_records" {
#   value = [ for dkim in aws_sesv2_email_identity.client-ses-domain-identity.dkim_signing_attributes : dkim.tokens ]
# }

output "ses_domain_records" {
  value = flatten([
    for dkim in aws_sesv2_email_identity.client-ses-domain-identity.dkim_signing_attributes : [
      for token in dkim.tokens : "${token}._domainkey.${data.local_file.domain-name-file.content} = ${token}.dkim.amazonses.com"
    ]
  ])
}



