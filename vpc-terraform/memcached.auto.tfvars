#memcached-vars.tf
memcached_cluster_id = "wp-project-memcached-cluster"
memcached_engine = "memcached"
memcached_cache_node_type = "cache.t3.micro"
memcached_num_cache_nodes = 3
memcached_az_mode = "cross-az"
memcached_security_group_name = "wp-project-memcached-sg"
memcached_parameter_group = "default.memcached1.6"
memcached_parameter_group_family = "memcached1.6"
memcached_tag = "WP Project Elasticache/Memcached Cluster"
