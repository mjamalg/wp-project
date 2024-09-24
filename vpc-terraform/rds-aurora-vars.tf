variable "rds_engine" {
    type = string
    description = "The database engine to use"
}

variable "rds_engine_version" {
    type = string
    description = "The database engine version to use"
}

variable "rds_instance_class" {
    type = string
    description = "Instance type to use at master instance."
}

variable "rds_security_group_name" {
    type = string
    description = "The name of the security group to associate with the cluster"
}


variable "rds_db_cluster_parameter_group_name" {
    type = string
    description = "Cluster parameter group name"
}

variable "rds_db_cluster_parameter_group_family" {
    type = string
    description = "Cluster parameter"
}

variable "rds_db_name" {
    type = string
    description = "The db name to create - if omitted no db is created initially"
}

variable "rds_db_master_username" {
    type = string
    description = "User name for the master db user"
}

variable "rds_db_master_password" {
    type = string
    description = "password for the master "
}

variable "rds_tag" {
    type = string
    description = "Tag value of the RDS resources created"
}