
output "aws_s3_bucket_name" {
  value = aws_s3_bucket.webbucket.bucket
}
output "bucketarn" {
  value = aws_s3_bucket.webbucket.arn

}