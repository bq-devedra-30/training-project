provider "aws" {
  region = var.region
}


resource "aws_instance" "web_servers" {
  count         = var.web_server_count
  ami           = var.web_server_ami
  instance_type = var.web_server_instance_type
  subnet_id     = var.private_subnate_ids #element(module.vpc.private_subnate_ids, count.index)
  security_groups = [aws_security_group.web_server_security_group.id]
  key_name      = var.key_name
  
user_data = <<-EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Hello from Web Server $(hostname -f)" > /var/www/html/index.html
EOF
}


resource "aws_security_group" "web_server_security_group" {
  name        = var.aws_security_group_webserver_name
  description = "Security group for web servers"
  vpc_id      = var.vpc_id

  # Ingress rules

  # Allow incoming HTTP traffic (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  # Egress rules

  # Allow all outgoing traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

