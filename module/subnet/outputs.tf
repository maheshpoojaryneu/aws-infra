output "vpc_public_subnets" {
  value = {
    for subnet in aws_subnet.public_subnets :
    subnet.id => subnet.cidr_block
    
  }
}