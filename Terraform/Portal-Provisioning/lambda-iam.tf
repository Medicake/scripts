# Creating the role to be used in terraform

resource "aws_iam_role" "lambda-webp-role" {
  name = "${var.client-name}-lambda-webp-role"
  assume_role_policy = "${file("iam/assume-lambda-policy.json")}"
}

# Creating the policy to be used by the lambda role
resource "aws_iam_policy" "lambda-webp-policy" {
  name = "${var.client-name}-lambda-webp-policy"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.client-asset-bucket}/*",
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOT
}

# Applying policy to lambda role
resource "aws_iam_role_policy_attachment" "lambda-webp-policy-attach" {
  role       = "${aws_iam_role.lambda-webp-role.name}"
  policy_arn = "${aws_iam_policy.lambda-webp-policy.arn}"
}