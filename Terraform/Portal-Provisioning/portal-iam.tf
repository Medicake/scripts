## Production s3 user

resource "aws_iam_user" "s3-upload-user" {
  name = "${var.client-name}_upload.s3.user"
}


resource "aws_iam_user_policy" "s3-bucket-access-policy" {
  name = "${var.client-name}-S3-Bucket-Policy"
  user = aws_iam_user.s3-upload-user.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl",
                "s3:ListMultipartUploadParts",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.client-asset-bucket}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::${var.client-asset-bucket}"
        }
    ]
}
  EOF
}

resource "aws_iam_user_group_membership" "mediaconvert-group-membership" {
  user = aws_iam_user.s3-upload-user.name
  groups = [
    var.mediaconvert-group
  ]
}

## Development s3 User

resource "aws_iam_user" "s3-dev-upload-user" {
  name = "${var.client-name}_upload.dev.s3.user"
}


resource "aws_iam_user_policy" "s3-dev-bucket-access-policy" {
  name = "${var.client-name}-S3-Dev-Bucket-Policy"
  user = aws_iam_user.s3-dev-upload-user.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl",
                "s3:ListMultipartUploadParts",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.client-asset-bucket}/${var.client-name}.development/*",
                "arn:aws:s3:::${var.client-asset-bucket}/"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::${var.client-asset-bucket}"
        }
    ]
}
  EOF
}

resource "aws_iam_user_group_membership" "dev-mediaconvert-group-membership" {
  user = aws_iam_user.s3-dev-upload-user.name
  groups = [
    var.mediaconvert-group
  ]
}

## Stage s3 User

resource "aws_iam_user" "s3-stage-upload-user" {
  name = "${var.client-name}_upload.stage.s3.user"
}


resource "aws_iam_user_policy" "s3-stage-bucket-access-policy" {
  name = "${var.client-name}-S3-Stage-Bucket-Policy"
  user = aws_iam_user.s3-stage-upload-user.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl",
                "s3:ListMultipartUploadParts",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.client-asset-bucket}/${var.client-name}.stage/*",
                "arn:aws:s3:::${var.client-asset-bucket}/"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::${var.client-asset-bucket}"
        }
    ]
}
  EOF
}

resource "aws_iam_user_group_membership" "stage-mediaconvert-group-membership" {
  user = aws_iam_user.s3-stage-upload-user.name
  groups = [
    var.mediaconvert-group
  ]
}

## SES USER

resource "aws_iam_user" "ses-user" {
  name = "${var.client-name}.ses.user"
}

resource "aws_iam_user_group_membership" "ses-group-membership" {
  user = aws_iam_user.ses-user.name
  groups = [
    var.ses-group
  ]
}