
module "efs" {
  source  = "terraform-aws-modules/efs/aws"

  # EFS Module has the following defaults - I needed this to keep costs low..feel free to change
  # throughput_mode = bursting 
  # performance_mode = generalPurpose
  
  name = var.efs_file_name  
  creation_token = var.efs_creation_token
  encrypted = true
  
  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

  mount_targets = { for k, v in zipmap(local.azs, module.vpc.database_subnets) : k => { subnet_id = v } } 

  security_group_name = var.efs_security_group_name
  security_group_description = var.efs_security_group_description
  security_group_vpc_id = module.vpc.vpc_id
  security_group_rules  = {
     vpc = {
       # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress) 
     description = "NFS ingress from VPC private subnets"
     cidr_blocks = module.vpc.private_subnets_cidr_blocks
     }
  }  
  
   access_points = {
    posix_user = {
        gid            = 1001
        uid            = 1001
        }
        
    wp_efs_root = {
    root_directory = {
     path = var.efs_root_path
     creation_info = {
        owner_gid = 1001
        owner_uid = 1001
        permissions = "777"
       } 
     }  
    }
  }
  
  enable_backup_policy = true
  create_replication_configuration = false   

  tags = {
    Name = var.efs_tag
  }

}
