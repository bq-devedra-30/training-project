#include "backend" {
 #path = find_in_parent_folders("backend.hcl")
#}
terraform {
  source = "../../../modules/project/elb"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "ec2-1" {
  config_path = "../ec2-1"
}

dependency "ec2-2" {
  config_path = "../ec2-2"
}
dependency "ec2-3" {
  config_path = "../ec2-3"
}

inputs = {
    #aws_lb_name  = "frontend_lb"
    internal  = false
    load_balancer_type = "application"
    enable_deletion_protection = false
    elb_protocol =  "HTTP"
    default_action = "forward"
    aws_lb_target_group_front_end_name = "application-target-group"
    aws_security_group_name = "alb_presentation_group"
    vpc_id = dependency.vpc.outputs.vpc_id
    public_subnets_ids = dependency.vpc.outputs.public_subnete_ids
    aws_lb_target_group_target_type = "instance"
    aws_lb_name = "frontend_lb"
    internal = false
    aws_lb_target_group_protocol = "HTTP"
    aws_security_group_protocol = "tcp"
    intance_count = 3
    instance_id = [
       dependency.ec2-1.outputs.web_server_ids[0],
       dependency.ec2-2.outputs.web_server_ids[0],
       dependency.ec2-3.outputs.web_server_ids[0]

    ]
 }

