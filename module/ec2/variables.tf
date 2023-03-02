variable "ec2_name" {
  type    = string
  default = "New EC2"

}
variable "key_name" {
  type    = string
  default = "ec2"
}
variable "ami_id" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "vpc_id" {

}
variable "vpc_security_group_ids" {

}
variable "iam_instance_profile" {

}
variable "aws_s3_bucket_name" {

}
data "aws_db_instance" "database" {
  db_instance_identifier = "csye6225"

}
# variable "username" {

# }
# variable "password" {

# }