
variable "memcached_engine" {
    type = string
    description = "Name of the Elasticache engine to use"
}


variable "memcached_cluster_id" {
    type = string
    description = "Cluster group identifier"
}

variable "memcached_cache_node_type" {
    type = string
    description = "The instance type of the Memcached nodes"
}

variable "memcached_num_cache_nodes" {
    type = number
    description = "Number of cache nodes"
}

variable "memcached_parameter_group" {
    type = string
    description = "memcache parameter group"
}

variable "memcached_parameter_group_family" {
    type = string
    description = "memcache parameter group"
}

variable "memcached_security_group_name" {
    type = string
    description = "Name of the security group"
}

variable "memcached_az_mode" {
    type = string
    description = <<EOT
    Whether the nodes in this Memcached node group are created in a single Availability Zone 
    or created across multiple Availability Zones in the cluster's region. 
    Valid values for this parameter are 'single-az' or 'cross-az'.
EOT
}

variable "memcached_tag" {
    type = string
    description = "Custom tag for Elasticache/Memcached Cluster Resources"
}