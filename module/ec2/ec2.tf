
resource "random_shuffle" "subnets" {
  input        = var.subnets
  result_count = 1
}






resource "aws_instance" "ec2" {
  ami                     = var.ami_id
  instance_type           = "t2.micro"
  key_name                = var.key_name
  vpc_security_group_ids  = [var.vpc_security_group_ids]
  disable_api_termination = false
  iam_instance_profile    = var.iam_instance_profile
  subnet_id               = random_shuffle.subnets.result[0]
  tags = {
    Name = "ec2 instance"
  }


  user_data = <<EOF


#!/bin/bash

touch /home/ec2-user/application.properties
sudo chown ec2-user:ec2-user /home/ec2-user/application.properties
sudo chmod 775 /home/ec2-user/application.properties
touch /home/ec2-user/webapp/application.log
sudo chown ec2-user:ec2-user /home/ec2-user/webapp/application.log
sudo chmod 775 /home/ec2-user/webapp/application.log

echo "spring.datasource.url=jdbc:mysql://"${data.aws_db_instance.database.endpoint}"/csye6225" >>  /home/ec2-user/application.properties
echo "spring.datasource.username=csye6225" >> /home/ec2-user/application.properties
echo "spring.datasource.password=Sqladmin#132$" >> /home/ec2-user/application.properties
echo "spring.jpa.hibernate.ddl-auto=update"  >> /home/ec2-user/application.properties
echo "spring.jpa.open-in-view=false" >> /home/ec2-user/application.properties
echo "spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver" >> /home/ec2-user/application.properties
echo "aws.s3.bucket.name="${var.aws_s3_bucket_name}"" >> /home/ec2-user/application.properties
echo "logging.file.name=application.log" >> /home/ec2-user/application.properties
echo "logging.file.path='/tmp'" >> /home/ec2-user/application.properties

sudo systemctl daemon-reload
sudo systemctl enable webapp
sudo systemctl start webapp
sudo systemctl enable amazon-cloudwatch-agent.service 
sudo systemctl start amazon-cloudwatch-agent.service
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/home/ec2-user/webapp/config.json -s


  EOF

  root_block_device {
    volume_size = 50
    volume_type = "gp2"

  }


}