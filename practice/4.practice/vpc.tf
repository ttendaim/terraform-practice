
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "custom_vpc"
  }
}



variable "vpc_availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.vpc_availability_zones)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name = "Public_subnet_${count.index + 1}"
  }

}

resource "aws_subnet" "private_subnet" {
  count             = length(var.vpc_availability_zones)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name = "Private_subnet_${count.index + 3}"
  }
}

# create internet gateway 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "igw_custom_vpc"
  }
}

# create public route table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_rt_custom_vpc"
  }

}

# associate public subnet with public route table

resource "aws_route_table_association" "public_rt_asso" {
  count          = length(var.vpc_availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# eip for nat gateway
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

# create nat gateway for private subnet

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "nat_gw_custom_vpc"
  }
}

# create private route table

resource "aws_route_table" "rt_private_subnet" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private subnet route table"
  }
}

# route table association private subnet

resource "aws_route_table_association" "private_subnet_assoc" {
  route_table_id = aws_route_table.rt_private_subnet.id
  count          = length(var.vpc_availability_zones)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}