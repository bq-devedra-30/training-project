variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "web_server_count" {
  description = "Number of web servers to launch"
  default     = 3
}

variable "web_server_ami" {
  description = "AMI ID for web servers"
  default     = "ami-053b0d53c279acc90"
}

variable "web_server_instance_type" {
  description = "Instance type for web servers"
  default     = "t2.micro"
}

variable "subnate_ids" {
  type    = list(string)
  default = [] # Populate with subnate IDs from the VPC component output
}

variable "private_subnate_ids" {
  type = string
}


variable "aws_security_group_webserver_name" {
  type = string
}

variable "vpc_id" {
   type = string
}

#  variable "security_group_id" {
#    type = string
# }

variable "key_name" {}