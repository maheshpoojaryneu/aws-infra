module "VPC" {
  source     = "./module/vpc"
  AWS_REGION = var.AWS_REGION
  cidr_block = var.cidr_block
  vpc_name   = var.vpc_name
}
module "subnet" {


  depends_on = [
    module.VPC,

  ]

  source     = "./module/subnet"
  vpc_id     = module.VPC.aws_vpc_id
  cidr_block = var.cidr_block
  vpc_name   = var.vpc_name
}

module "sg" {
  source = "./module/sg"
  vpc_id = module.VPC.aws_vpc_id

  depends_on = [
    module.VPC,
  ]
}
# module "ec2" {

#   depends_on = [
#     module.VPC,
#     module.subnet,
#     module.sg,
#     module.s3,
#     module.db,
#   ]
#   source                 = "./module/ec2"
#   ami_id                 = var.ami_id
#   subnets                = keys(module.subnet.vpc_public_subnets)
#   vpc_id                 = module.VPC.aws_vpc_id
#   vpc_security_group_ids = module.sg.vpc_security_group_ids
#   iam_instance_profile   = module.policy.iam_instance_profile
#   aws_s3_bucket_name     = module.s3.aws_s3_bucket_name
# }

module "db" {

  depends_on = [
    module.VPC,
    module.subnet,
    module.sg,

  ]

  source            = "./module/db"
  subnets           = keys(module.subnet.vpc_public_subnets)
  security_group_id = module.sg.security_group_id
  vpc_id            = module.VPC.aws_vpc_id
}

module "s3" {
  depends_on = [

  ]
  source = "./module/s3"


}

module "policy" {
  source = "./module/policy"
  depends_on = [module.s3,

  ]
  bucketarn = module.s3.bucketarn

}

module "route53" {

  source = "./module/route53"
  # ec2_ip    = module.ec2.instance_public_ip
  zone_name = var.zone_name
  depends_on = [
    module.loadbalancer,
  ]

}

module "loadbalancer" {
  iam_instance_profile   = module.policy.iam_instance_profile
  ami_id                 = var.ami_id
  source                 = "./module/loadbalancer"
  vpc_id                 = module.VPC.aws_vpc_id
  vpc_zone_identifier    = keys(module.subnet.vpc_public_subnets)
  security_group_id      = module.sg.loadbalancer_group_id
  publicsubnets          = keys(module.subnet.vpc_public_subnets)
  aws_s3_bucket_name     = module.s3.aws_s3_bucket_name
  vpc_security_group_ids = module.sg.vpc_security_group_ids
  # iam_role_arn = module.policy.iam_role_arn

  depends_on = [
    module.VPC,
    module.subnet,
    module.sg,
    module.s3,
    module.db,
    module.policy,
  ]
}