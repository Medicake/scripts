resource "aws_cloudwatch_metric_alarm" "lambda-error-alarm" {
  alarm_name = "${var.client-name}-lambda-webp-error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "Errors"
  namespace = "AWS/Lambda"
  statistic = "Sum"
  period = "60"
  threshold = "1"
  actions_enabled = "true"
  alarm_actions = ["${var.cloud-watch-snstopic}"]
  ok_actions = ["${var.cloud-watch-snstopic}"]
  treat_missing_data = "ignore"
  dimensions = {
    FunctionName = "${aws_lambda_function.lambda-webp-function.function_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda-invocation-alarm" {
  alarm_name = "${var.client-name}-lambda-webp-invocation"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "3"
  metric_name = "Invocations"
  namespace = "AWS/Lambda"
  statistic = "Sum"
  period = "60"
  threshold = "100"
  actions_enabled = "true"
  alarm_actions = ["${var.cloud-watch-snstopic}"]
  ok_actions = ["${var.cloud-watch-snstopic}"]
  treat_missing_data = "ignore"
  dimensions = {
    FunctionName = "${aws_lambda_function.lambda-webp-function.function_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda-throttle-alarm" {
  alarm_name = "${var.client-name}-lambda-webp-throttle"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "3"
  metric_name = "Throttles"
  namespace = "AWS/Lambda"
  statistic = "Sum"
  period = "60"
  threshold = "100"
  actions_enabled = "true"
  alarm_actions = ["${var.cloud-watch-snstopic}"]
  ok_actions = ["${var.cloud-watch-snstopic}"]
  treat_missing_data = "ignore"
  dimensions = {
    FunctionName = "${aws_lambda_function.lambda-webp-function.function_name}"
  }
}