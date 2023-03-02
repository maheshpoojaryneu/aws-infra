//variable "public_subnet_cidrs" {
//  type        = list(string)
//description = "Public subnet CIDR values"
//default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
//}


//variable "private_subnet_cidrs" {
// type        = list(string)
// description = "Private subnet CIDR values"
//  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
//}
//variable "azs" {
// type        = list(string)
// description = "Availability zones"
//default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
//}
variable "vpc_id" {
  type = string
}
variable "cidr_block" {
}
variable "vpc_name" {
}
data "aws_availability_zones" "available" {
  state = "available"
}
