
resource "aws_db_parameter_group" "pg-database" {
  name   = "pg-database"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_subnet_group" "db-subnetg" {
  name       = "db-subnetg"
  subnet_ids = var.subnets

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  db_name                = "csye6225"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.username
  password               = var.password
  parameter_group_name   = aws_db_parameter_group.pg-database.name
  publicly_accessible    = false
  multi_az               = false
  identifier             = "csye6225"
  db_subnet_group_name   = aws_db_subnet_group.db-subnetg.name
  vpc_security_group_ids = var.security_group_id
  skip_final_snapshot    = true

}
