include "backend" {
  path = find_in_parent_folders("backend.hcl")
}

terraform {
  source = "../../../modules/project/vpc"
}

# See source module for input descriptions
inputs ={
    main_cidr_block = "10.0.0.0/16"
    public_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    private_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
    region = "us-east-1"
    enable_dns_hostnames = false
    enable_dns_support  = false
    aws_availability_zones_state = "available"
    aws_vpc_tagname = "main"
    public_subnets_map_public_ip_on_launch = true
    private_subnets_map_public_ip_on_launch = false
    aws_security_group_name = "presentation_tier_connection"
    aws_security_group_protocol = "tcp"
  }
