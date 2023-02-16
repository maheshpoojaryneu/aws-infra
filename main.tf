module "VPC" {
  source     = "./module/vpc"
  AWS_REGION = var.AWS_REGION
  cidr_block = var.cidr_block
  vpc_name = var.vpc_name
}
module "subnet" {


  depends_on = [
    module.VPC,

  ]

  source = "./module/subnet"
  vpc_id = module.VPC.aws_vpc_id
  cidr_block = var.cidr_block
  vpc_name = var.vpc_name
}

