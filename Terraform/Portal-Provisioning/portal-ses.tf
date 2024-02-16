# Used for SES Bounce Queue

resource "aws_sqs_queue" "portal_sqs_bounce_queue" {
  name = "${var.client-name}-ses-bounce-queue"
  message_retention_seconds = 86400
}

resource "aws_sns_topic" "portal_sns_bounce_topic" {
  name = "${var.client-name}-ses-bounce-topic"
}

resource "aws_sns_topic_subscription" "portal_sns_bounce_sub" {
  topic_arn = aws_sns_topic.portal_sns_bounce_topic.arn
  protocol = "sqs"
  endpoint = aws_sqs_queue.portal_sqs_bounce_queue.arn
}