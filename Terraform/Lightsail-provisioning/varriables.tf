variable "aws-region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

data "local_file" "client-name-file"{
  filename = "clientname.txt"
}

data "local_file" "domain-name-file"{
  filename = "domain.txt"
}


# data "local_file" "client-zone-file"{
#   filename = "clientzone.txt"
# }


# variable "client-name" {
#   description = "Name of client"
#   type = string
#   default = "${data.local_file.client-name-file.content}"
#   nullable = false
# }

variable "aws-account-id" {
  description = "Account number for the AWS account"
  type = string
  default = "null"
  nullable = false
}

variable "ses-rep-sns-topic" {
  description = "SNS topic for alarms and ok from cloudwatch (ARN)"
  type = string
  default = "arn:aws:sns:us-east-1:null:AWS-SNS-Reputation-Notifcation"
  nullable = false
}

variable "access_key" {
  description = "Please input access key with required permissions"
  type = string
  nullable = false
}

variable "secret_key" {
  description = "Please input secret key with required permissions"
  type = string
  nullable = false
}