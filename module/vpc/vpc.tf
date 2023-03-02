resource "aws_vpc" "vpc_new" {

  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}
