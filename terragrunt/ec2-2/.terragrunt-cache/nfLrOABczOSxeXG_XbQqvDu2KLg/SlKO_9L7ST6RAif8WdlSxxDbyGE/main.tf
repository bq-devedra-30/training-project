provider "aws" {
  region = var.region
}


resource "aws_instance" "web_servers" {
  count         = var.web_server_count
  ami           = var.web_server_ami
  instance_type = var.web_server_instance_type
  subnet_id     = var.private_subnate_ids #element(module.vpc.private_subnate_ids, count.index)



  

user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
service httpd start

# Place your web application deployment or configuration steps here
# For example, you can copy your website files to the appropriate directory

# Replace the following line with your specific web content setup
echo "Hello from Web Server ${count.index}" > /var/www/html/index.html

# End of user data script
EOF
}



