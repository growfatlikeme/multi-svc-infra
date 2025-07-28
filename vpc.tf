#create VPC

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  cidr = "172.16.16.0/20"

  azs            = var.azs
  public_subnets = ["172.16.17.0/24", "172.16.18.0/24", "172.16.19.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "${local.name_prefix}-vpc"
  }

  public_subnet_names = [
    "${local.name_prefix}-public-subnet-1",
    "${local.name_prefix}-public-subnet-2",
    "${local.name_prefix}-public-subnet-3"
  ]

  igw_tags = {
    Name = "${local.name_prefix}-igw"
  }
}