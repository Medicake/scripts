variable "aws-region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "client-name" {
  description = "Name of client"
  type = string
  default = "dantest"
  nullable = false
}

variable "client-asset-bucket" {
  description = "Name of bucket containing client assets"
  type = string
  default = "dantest-resources-dantesthosting"
  nullable = false
}

variable "lambda-code-bucket" {
  description = "Name of bucket containing lambda deployment package"
  type = string
  default = "dantest-it-scripts"
  nullable = false
}

variable "lambda-function-zip" {
  description = "Name of lambda function zip file"
  type = string
  default = "webp-resize-function.zip"
  nullable = false
}

variable "aws-account-id" {
  description = "Account number for the AWS account"
  type = string
  default = "awsaccid"
  nullable = false
}

variable "cloud-watch-snstopic" {
  description = "SNS topic for alarms and ok from cloudwatch (ARN)"
  type = string
  default = "arn:aws:sns:us-east-1:awsaccid:IT"
  nullable = false
}

variable "mediaconvert-group" {
  description = "group used to grant access to jobs"
  type = string 
  default = "MediaConvert_JobAccess"
  nullable = false
}

variable "ses-group" {
  description = "group used to grant access to jobs"
  type = string 
  default = "ses_send_only_group"
  nullable = false
}

variable "addtional-cors" {
  description = "cors not coverted by client .net, .org, .com"
  type = string
  default = "dantest.com"
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