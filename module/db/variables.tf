variable "subnets" {
  type = list(string)
}
variable "security_group_id" {

}
variable "vpc_id" {

}
variable "username" {
  type    = string
  default = "csye6225"
}
variable "password" {
  type    = string
  default = "Sqladmin#132$"
}