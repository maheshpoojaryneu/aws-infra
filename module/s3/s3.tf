resource "random_id" "my-random-id" {
  byte_length = 8
}

resource "aws_s3_bucket" "webbucket" {
  bucket        = "webbucket-${random_id.my-random-id.dec}"
  force_destroy = true
}


resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {

  depends_on = [aws_s3_bucket.webbucket]
  bucket     = aws_s3_bucket.webbucket.id

  rule {
    id = "log"

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.webbucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3encrypt" {
  bucket = aws_s3_bucket.webbucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


