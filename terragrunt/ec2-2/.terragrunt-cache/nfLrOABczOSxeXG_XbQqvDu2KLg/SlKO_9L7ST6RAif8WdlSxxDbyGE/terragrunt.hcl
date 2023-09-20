
terraform {
  source = "../../../modules/project/ec2"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
   region = "us-east-1"
   web_server_count = 1
   web_server_ami = "ami-04cb4ca688797756f"
   web_server_instance_type = "t2.micro"
   private_subnate_ids = dependency.vpc.outputs.private_subnate_ids[1]
   vpc_id = dependency.vpc.outputs.vpc_id

}