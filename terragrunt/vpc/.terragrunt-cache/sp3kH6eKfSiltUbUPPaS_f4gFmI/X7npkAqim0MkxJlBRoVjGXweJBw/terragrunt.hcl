

terraform {
  source = "../../../modules/project/vpc"
}

# See source module for input descriptions
inputs ={
  vpc_cidr = "10.0.0.0/24"
  aws_vpc_tags = "vpc"
  aws_availability_zones_state = "available"
  map_public_ip_on_launch = true
  #aws_public_subnate_tags = "public_subnet_${count.index + 1}"
  #aws_private_subnate_tags  = "private_subnet_${count.index + 1}"
  aws_nat_gateway_tags = "ngw"
  aws_eip_tags = "eip"
  aws_route_table_private_tags = "privateroute"
  aws_route_table_public_tags = "publicroute"
  aws_internet_gateway_tags = "igw"
  #aws_route_table_cidr = "0.0.0.0/0"
  #public_cidr_blocks = ["10.0.0.0/28", "10.0.0.32/28"]
  #private_cidr_blocks = ["10.0.0.16/28", "10.0.0.48/28"]
  }
