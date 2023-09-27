resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    name = var.aws_vpc_tags
  }
}

data "aws_availability_zones" "available" {
  state = var.aws_availability_zones_state
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

# Creat private subnets in the first two availability zones
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}
resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = var.aws_internet_gateway_tags
  }

}
resource "aws_route_table" "public_aws_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
  }
  tags = {
    name = var.aws_route_table_public_tags
  }

}
resource "aws_route_table" "private_aws_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.aws_ngw.id
  }
  tags = {
    name = var.aws_route_table_private_tags
  }

}
resource "aws_nat_gateway" "aws_ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    name = var.aws_nat_gateway_tags
  }
  depends_on = [aws_internet_gateway.aws_igw]
}

resource "aws_eip" "eip" {
  #depends_on = [aws_internet_gateway.gw]
  tags = {
    name = var.aws_eip_tags
  }

}

resource "aws_route_table_association" "aws_rta" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_aws_rt.id

}

resource "aws_route_table_association" "aws_private_rta" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_aws_rt.id

}






