#include "backend" {
 #path = find_in_parent_folders("backend.hcl")
#}

terraform {
  source = "../../../modules/project/ec2"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
   region = "ap-south-1"
   web_server_count = 1
   web_server_ami = "ami-08e5424edfe926b43"
   web_server_instance_type = "t2.micro"
   private_subnate_ids = dependency.vpc.outputs.private_subnate_ids[1]
   vpc_id = dependency.vpc.outputs.vpc_id
   aws_security_group_webserver_name = "webserver_securitygroup1"
   key_name = "new-key12"
   

}