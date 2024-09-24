module "elasticache" {
  source = "terraform-aws-modules/elasticache/aws"
 
  #Memcache
  cluster_id               = var.memcached_cluster_id
  create_cluster           = true
  create_replication_group = false

  engine          = var.memcached_engine
  node_type       = var.memcached_cache_node_type
  num_cache_nodes = var.memcached_num_cache_nodes
  az_mode         = var.memcached_az_mode

  transit_encryption_enabled = true # default but placed here for readability

  # Security group
  vpc_id = module.vpc.vpc_id
  security_group_name = var.memcached_security_group_name
  security_group_rules = {
    ingress_vpc = {
      # Default type is `ingress`
      # Default port is based on the default engine port 11211
      description = "WP Project VPC Ingress Traffic"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }
  security_group_tags = { Name = "${var.vpc_custom_name} Memcached Sgr" }

  # Subnet Group 
  subnet_group_name = module.vpc.database_subnet_group
  subnet_ids = module.vpc.database_subnets

  # Parameter Group
  create_parameter_group = false # default
  parameter_group_name = var.memcached_parameter_group
  parameter_group_family = var.memcached_parameter_group_family

  tags = {
    Name = var.memcached_tag
  }
}
