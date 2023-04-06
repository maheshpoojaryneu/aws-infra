# variable "ec2_ip" {

# }
variable "zone_name" {
  type = string
}
data "aws_lb" "webapplb" {

name = "webapplb"

}