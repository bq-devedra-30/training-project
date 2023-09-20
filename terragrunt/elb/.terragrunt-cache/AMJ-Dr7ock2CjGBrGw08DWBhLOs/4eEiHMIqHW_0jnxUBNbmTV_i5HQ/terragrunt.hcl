include "backend" {
  path = find_in_parent_folders("backend.hcl")
}
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
    aws_lb_name  = "frontend-lb"
    internal  = false
    load_balancer_type = "application"
    enable_deletion_protection = false
    elb_protocol =  "HTTP"
    default_action = "forward"
    aws_lb_target_group_front_end_name = "application-target-group"
    vpc_id = dependency.vpc.outputs.vpc_id
    public_subnets_ids = dependency.vpc.outputs.public_subnets_ids
    security_group_id =  dependency.vpc.outputs.security_group_id
    intance_count = 1
    instance_id = dependency.ec2-1.outputs.web_server_ids[0]
    }

