
module "rds-aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.9.1" # Latest at the time when this was created
 
  name = "wp-project-rds"
  vpc_id = module.vpc.vpc_id 
  
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_class
   instances = {
    1 = {}
    2 = {}
    3 = {}
   }

  manage_master_user_password = false

  master_username = jsondecode(aws_secretsmanager_secret_version.wp-project-secret-version.secret_string)["username"]
  master_password = jsondecode(aws_secretsmanager_secret_version.wp-project-secret-version.secret_string)["mariadb-password"]
  database_name = var.rds_db_name

  availability_zones = local.azs
 
  db_cluster_parameter_group_name = var.rds_db_cluster_parameter_group_name 
  db_cluster_parameter_group_family = var.rds_db_cluster_parameter_group_family
  db_subnet_group_name =  module.vpc.database_subnet_group_name

  security_group_name = var.rds_security_group_name
  security_group_rules = {
    vpc-ingress = {
      cidr_blocks = [ module.vpc.vpc_cidr_block ]
    }
  }

  port     = "3306"

  backup_retention_period = 1
  delete_automated_backups = true
  deletion_protection = false
  skip_final_snapshot = true
  
  apply_immediately   = true
  storage_encrypted = true

  tags = {
    Name = var.rds_tag
  }
}
