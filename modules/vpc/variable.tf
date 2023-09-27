variable "vpc_cidr" {
  type = string

}
variable "aws_availability_zones_state" {
  type = string
}
variable "map_public_ip_on_launch" {
  type = bool
  
}

variable "aws_vpc_tags" {
  type = string
  
}

# variable "aws_public_subnate_tags" {
#   type = string
# }
# variable "aws_private_subnate_tags" {
#   type = string
# }
variable "aws_internet_gateway_tags" {
  type = string
  
}

variable "aws_nat_gateway_tags" {
  type = string
}
variable "aws_eip_tags" {
  type = string
}

#
variable "public_cidr_blocks" {
 default = ["10.0.0.0/28", "10.0.0.32/28"]
}

variable "private_cidr_blocks" {
default = ["10.0.0.16/28", "10.0.0.48/28"]

}
variable "aws_route_table_public_tags" {
  
}
variable "aws_route_table_private_tags" {
  
}