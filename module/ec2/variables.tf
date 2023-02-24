variable "ec2_name" {
    type = string
    default = "New EC2"

}
variable "key_name" {
    type = string
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
