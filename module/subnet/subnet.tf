
resource "aws_subnet" "public_subnets" {
  count             = 3
  cidr_block = "${cidrsubnet(var.cidr_block, 2,count.index + 1)}"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = "${var.vpc_id}"
  map_public_ip_on_launch = true
  tags = {
    Name = " ${var.vpc_name} Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = 3
  cidr_block        = "${cidrsubnet(var.cidr_block, 8 ,count.index + 1)}"
    availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "${var.vpc_name} Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igateway" {
 vpc_id = "${var.vpc_id}"
 
 tags = {
   Name = "${var.vpc_name} Public Gateway"
 }
}

resource "aws_route_table" "public_route" {
 vpc_id = "${var.vpc_id}"
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igateway.id
 }
 
 tags = {
   Name = "${var.vpc_name} Public Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_association" {
 count = 3
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
 vpc_id = "${var.vpc_id}"

 
 tags = {
   Name = "${var.vpc_name} Private Route Table"
 }
}

resource "aws_route_table_association" "private_subnet_association" {
 count = 3
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = aws_route_table.private_route.id
}  


