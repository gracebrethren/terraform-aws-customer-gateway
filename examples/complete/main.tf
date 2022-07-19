provider "aws" {
  region = "us-west-1"
}

module "cgw" {
  source = "../../"

  name = "gbs-HS-cgw"

  customer_gateways = {
    IP1 = {
      bgp_asn    = 65000
      ip_address = "209.64.100.10"
    }
  }

  tags = {
    Test = "yes"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "gbs-cloud"

  # 10.100.110.0 thru 10.100.111.255:
  cidr = "10.100.110.0/23"

  azs             = ["us-west-1b","us-west-1c"]
  private_subnets = var.vpc_private_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = true

  tags = {
    Name  = "gbs-cloud"
  }
}

module "vpn_gateway_1" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.0"

  vpn_gateway_id      = module.vpc.vgw_id
  customer_gateway_id = module.cgw.ids[0]

  vpc_id                       = module.vpc.vpc_id
  vpc_subnet_route_table_ids   = module.vpc.private_route_table_ids
  vpc_subnet_route_table_count = length(var.vpc_private_subnets)
}
