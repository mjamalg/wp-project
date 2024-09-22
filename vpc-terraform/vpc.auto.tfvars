#vpc-vars.tf
vpc_cidr_block = "10.22.0.0/16"
vpc_custom_name = "WP Project"
vpc_public_rtb_tag = "WP Project Public Rtb"
vpc_private_app_rtb_tag = "WP Project Private App Rtb"
vpc_private_data_rtb_tag = "WP Project Private Data/Database Rtb"
vpc_nat_gateway_tag = "WP Project Private NatGW"
vpc_igw_tag = "WP Project Public IGW"
vpc_database_subnet_group_name = "wp-project-sn-grp"