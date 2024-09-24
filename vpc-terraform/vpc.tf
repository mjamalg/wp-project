locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_custom_name
  cidr = var.vpc_cidr_block

  azs               = local.azs
  public_subnets    = [ for k,v in local.azs : cidrsubnet(var.vpc_cidr_block, 4, k)   ]
  private_subnets   = [ for k,v in local.azs : cidrsubnet(var.vpc_cidr_block, 4, k+3) ]
  database_subnets  = [ for k,v in local.azs : cidrsubnet(var.vpc_cidr_block, 4, k+6) ]
  
  # One NatGW Per AZ as prescribed in the Best Practices White Paper
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true
  nat_gateway_tags = { Name = var.vpc_nat_gateway_tag }
   
  create_igw = true # default but put here for readability
  igw_tags = { Name = var.vpc_igw_tag }

  #Enable DNS Hostnames Necessary For External-DNS
  enable_dns_hostnames = true
  enable_dns_support = true

  #What I Dont Want/Need  
  enable_vpn_gateway = false 
  manage_default_vpc = false
  manage_default_network_acl = false
  manage_default_route_table = false
  manage_default_security_group = false

  #Names and Tags
  public_subnet_names = [ for k,v in local.azs : format("${var.vpc_custom_name}-pub-%s",split("-",v)[2]) ]
  public_route_table_tags = { Name = var.vpc_public_rtb_tag }
  public_subnet_tags = { "kubernetes.io/role/elb" = 1 } #Needed for AWS Load Balancer Controller DO NOT CHANGE!!!

  private_subnet_names = [ for k,v in local.azs : format("${var.vpc_custom_name}-priv-app-%s",split("-",v)[2]) ]
  private_route_table_tags = { Name = var.vpc_private_app_rtb_tag }
  private_subnet_tags = {  "kubernetes.io/role/internal-elb" = 1 } #Needed for AWS Load Balancer Controller DO NOT CHANGE!!!
 
  database_subnet_names = [ for k,v in local.azs : format("${var.vpc_custom_name}-priv-data-%s",split("-",v)[2]) ]
  database_route_table_tags = { Name = var.vpc_private_data_rtb_tag }
  database_subnet_group_name = var.vpc_database_subnet_group_name
   
}
