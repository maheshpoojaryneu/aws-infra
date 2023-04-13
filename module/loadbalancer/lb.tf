
data "aws_caller_identity" "current" {}
# resource "aws_kms_key" "ebskey" {
#   description = "EBS Key"
#   policy = jsonencode({
#     Id = "ebskeypolicy"
#     Statement = [
#       {
#         Action = ["kms:Encrypt*",
#         "kms:Decrypt*",
#         "kms:ReEcrypt*",
#         "kms:GenerateDataKey*",
#         "kms:Describe*"] 
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }

#         Resource = "*"
#         Sid      = "Enable IAM User Permissions"
#       },
#     ]
#     Version = "2012-10-17"
#   })
# }

resource "aws_kms_key" "ebskey" {
  description              = "EBS Key"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 10
  policy = jsonencode({
    "Id" : "ebskeypolicy",
    "Version" : "2012-10-17",

    "Statement" : [

      {

        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {

        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

          ]

        },

        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],

        "Resource" : "*"

      },

      {

        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

          ]

        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"

        ],

        "Resource" : "*"
      },

      {

        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [

            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"

          ]

        },

        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],

        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}



data "template_file" "user_data" {

  template = <<EOF

 #!/bin/bash

echo "test" > /opt/user_data_test.txt

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

}


resource "aws_launch_template" "launchtemplate" {
  name = "launchtemplate"

  # root_block_device {
  #   volume_size = 50
  #   volume_type = "gp2"

  # }
  #associate_public_ip_address = true
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = "ec2"
  #disable_api_termination = true

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  block_device_mappings {

    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = aws_kms_key.ebskey.arn
    }
  }


  #iam_instance_profile    = var.iam_instance_profile
  #subnet_id               = random_shuffle.subnets.result[0]

  lifecycle {
    create_before_destroy = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.vpc_security_group_ids]
  }
  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "ec2 instance"
    }

  }
  user_data = base64encode(data.template_file.user_data.rendered)

}



resource "aws_lb" "webapplb" {
  name               = "webapplb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.publicsubnets
  tags = {

    Application = "WebApp"

  }

}

resource "aws_lb_listener" "webapp_listener" {
  load_balancer_arn = aws_lb.webapplb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.awslb_tg.arn
  }
  certificate_arn = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/557fc61c-f048-45dd-bf86-920572bbaf3b"
}



resource "aws_lb_target_group" "awslb_tg" {
  name     = "csye6225-lb-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/healthz"
  }
}

resource "aws_autoscaling_attachment" "autoscaleattach" {
  autoscaling_group_name = aws_autoscaling_group.asg_launch_config.id
  lb_target_group_arn    = aws_lb_target_group.awslb_tg.arn
}


resource "aws_autoscaling_group" "asg_launch_config" {


  name                = "asg_launch_config"
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  force_delete        = true
  health_check_type   = "EC2"

  depends_on = [
    aws_launch_template.launchtemplate,
    aws_lb_target_group.awslb_tg,
  ]

  launch_template {
    id      = aws_launch_template.launchtemplate.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.awslb_tg.arn]
  tag {

    key   = "name"
    value = "asg_launch_config"

    propagate_at_launch = true

  }



}

resource "aws_autoscaling_policy" "scale_up" {

  name                   = "scale_up"
  cooldown               = 60
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  autoscaling_group_name = aws_autoscaling_group.asg_launch_config.name


}

resource "aws_autoscaling_policy" "scale_down" {

  name                   = "scale_down"
  cooldown               = 60
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  autoscaling_group_name = aws_autoscaling_group.asg_launch_config.name


}



resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors High CPU utilization for Web App"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "webapp_scale_down"
  comparison_operator = "LessThanThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "5"
  evaluation_periods  = "1"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_launch_config.name
  }
}


resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors Low CPU utilization for Web App"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = "webapp_scale_up"
  comparison_operator = "GreaterThanThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "1"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_launch_config.name
  }
}


# resource "aws_lb_target_group_attachment" "alg_tg_attach" {
#   target_group_arn = aws_lb_target_group.alg_tg.arn
#   target_id        = 
#   port             = 80
# }




