
resource "random_shuffle" "subnets"{
input = var.subnets
result_count =1
}
resource "aws_security_group" "application" {
  name = "application"
  vpc_id = "${var.vpc_id}"
  #Incoming traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_instance" "ec2" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [aws_security_group.application.id]
  disable_api_termination = false
  

  subnet_id = random_shuffle.subnets.result[0]
  
  root_block_device {
  volume_size = 50
  volume_type = "gp2"
  
  }
    

}


