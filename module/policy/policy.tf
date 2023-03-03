resource "aws_iam_policy" "bucket_policy" {
  name        = "my-bucket-policy"
  description = "Allow "

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListObjectsInBucket",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "${var.bucketarn}"
      ]
    },
    {
      "Sid": "AllObjectActions",
      "Effect": "Allow",
      "Action": "s3:*Object*",
      "Resource": [
        "${var.bucketarn}/*"
      ]
    }
  ]
})
}

resource "aws_iam_role" "webaccess_role" {
  name = "my_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_bucket_policy" {
  role       = aws_iam_role.webaccess_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}


resource "aws_iam_instance_profile" "webaccess_profile" {
  name = "ec2-profile"
  role = aws_iam_role.webaccess_role.name
}

