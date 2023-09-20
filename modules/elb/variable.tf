 variable "aws_lb_name" {
   default = "frontend_lb"
 }

variable "internal" {
    type = bool
    default =  false
  
}

 variable "load_balancer_type" {
     type = string
     default = "application"
 }

variable "enable_deletion_protection" {
    type = bool
    default = false
  
}


variable "elb_protocol" {
    type = string
    default = "HTTP"
  
}

variable "default_action" {
    type = string
    default = "forward"
   
 }

  variable "aws_lb_target_group_front_end_name" {
     type = string
     default = "application-target-group"
   
  }


variable "aws_lb_target_group_protocol" {
    type = string
    default = "HTTP"
}
variable "security_group_id" {}
 
 variable "vpc_id" {}

variable "intance_count" {}

variable "public_subnets_ids" {
  type        = list(string)
  default     = null
}

variable "instance_id" {}
