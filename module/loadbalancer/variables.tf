variable "vpc_id" {

}
variable "vpc_zone_identifier" {
  type = list(string)
}
variable "security_group_id" {

}
variable "publicsubnets" {
  type = list(string)
}
data "aws_db_instance" "database" {
  db_instance_identifier = "csye6225"

}
variable "aws_s3_bucket_name" {

}
variable "vpc_security_group_ids" {

}

variable "ami_id" {

}
variable "iam_instance_profile" {

}
# variable "iam_instance_profile_arn" {

# }
# variable "iam_role_arn" {

# }