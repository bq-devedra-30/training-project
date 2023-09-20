# Declare the VPC
resource "aws_vpc" "main" {
  cidr_block = var.main_cidr_block

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.aws_vpc_tagname
  }
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = var.aws_availability_zones_state
}

# Creat public subnets in the first two availability zones
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.public_subnets_map_public_ip_on_launch

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

# Creat private subnets in the first two availability zones
resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.private_subnets_map_public_ip_on_launch

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

# resource "aws_security_group" "presentation_tier" {
#   name        = var.aws_security_group_name
#   description = "Allow HTTP requests"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description     = "HTTP from anywhere"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_presentation_tier.id]
#   }

#   ingress {
#     description     = "HTTP from anywhere"
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_presentation_tier.id]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "presentation_tier_sg"
#   }
# }

resource "aws_security_group" "alb_presentation_tier" {
  name        = "alb_presentation_tier_connection"
  description = "Allow HTTP requests"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = var.aws_security_group_protocol
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 3000
    to_port          = 3000
    protocol         = var.aws_security_group_protocol
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_presentation_tier_sg"
  }
}

# resource "aws_security_group" "application_tier" {
#   name        = "application_tier_connection"
#   description = "Allow HTTP requests"
#   vpc_id      = aws_vpc.main.id
#   ingress {
#     description     = "HTTP from public subnet"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_application_tier.id]
#   }

#   ingress {
#     description     = "HTTP from public subnet"
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_application_tier.id]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "application_tier_sg"
#   }
# }

# resource "aws_security_group" "alb_application_tier" {
#   name        = "alb_application_tier_connection"
#   description = "Allow HTTP requests"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description     = "HTTP from anywhere"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.presentation_tier.id]
#   }

#   ingress {
#     description     = "HTTP from anywhere"
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.presentation_tier.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "alb_application_tier_sg"
#   }
# }

 resource "aws_internet_gateway" "gw" {
   vpc_id = aws_vpc.main.id

   tags = {
     Name = "main"
   }
 }

resource "aws_nat_gateway" "gw" {
  count         = length(aws_subnet.public_subnets)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  depends_on    = [aws_internet_gateway.gw]
  tags = {
    "Name" = "nat_gw_${count.index + 1}"
  }
}

resource "aws_eip" "nat_ip" {
  count      = length(aws_subnet.public_subnets)
  depends_on = [aws_internet_gateway.gw]
  tags = {
    "Name" = "nat_ip_${count.index + 1}"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw[count.index].id
  }
  tags = {
    Name = "private_route_${count.index + 1}"
  }
}

resource "aws_route_table_association" "private-route" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route[count.index].id
}


