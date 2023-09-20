variable "main_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "private_cidr_blocks" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "region" {
    type = string
    default = "us-east-1"
}
variable "enable_dns_hostnames" {
  type = bool
  default = false

}
variable "enable_dns_support" {
  type = bool
  default = false
  
}

variable "aws_availability_zones_state" {
  type = string
  default = "available"
  
}

variable "aws_vpc_tagname" {
  type = string
  default = "main"
  
}

variable "public_subnets_map_public_ip_on_launch" {
  type = bool
  default = true
  
}


variable "private_subnets_map_public_ip_on_launch" {
  type = bool
  default = false
  
}

variable "aws_security_group_name" {
   type  = string
   default = "presentation_tier_connection" 
}

variable "aws_security_group_protocol" {
  type = string
  default = "tcp"
}
