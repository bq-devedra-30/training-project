# variable "aws_lb_name" {
#   type = string
# }

variable "internal" {
  type    = bool
}

variable "load_balancer_type" {
  type    = string
}

variable "enable_deletion_protection" {
  type    = bool
}

variable "elb_protocol" {
  type    = string
}

variable "default_action" {
  type    = string
}

variable "aws_lb_target_group_front_end_name" {
  type = string
}


variable "aws_lb_target_group_protocol" {
  type    = string
}


variable "vpc_id" {
  type = string
}

variable "intance_count" {
  type = number
}

variable "public_subnets_ids" {
  type    = list(string)
  default = null
}

variable "instance_id" {
  type = list(string)
  default = []
}

variable "aws_security_group_protocol" {
  type    = string
}

variable "aws_security_group_name" {
  type = string
}
variable "aws_lb_target_group_target_type" {
  type = string
  
}

