variable "efs_file_name" {
    type = string
    description = "The name of the file system"
}

variable "efs_creation_token" {
    type = string
    description = "Uniqe name used as a refence when creating filesystem"
}

variable "efs_security_group_name" {
  type = string
  description = "Name of the security group"
}

variable "efs_security_group_description" {
    type = string
    description = "Security group description"
}

variable "efs_root_path" {
    type = string
    description = "Custom root directory file system path name"
}

variable "efs_tag" {
    type = string
    description = "Custom tag for EFS resources"
}