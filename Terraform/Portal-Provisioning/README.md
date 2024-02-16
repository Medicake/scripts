This Terraform project was created to allow for ease of provisioning AWS resources for a .net application


The terraform scripts will perform the following actions:
- Create a cloudfront distribution for site asset hosting
- Generate a lambda function to perform webp conversion of existing assets along with alarms to notify if conversions fail
- Create S3 buckets for asset storage for various environments
- Generate SQS queues to process bounced emails via SNS from AWS SES (SES setup is still a manual step due to client configuration variation)

