# This one is for creating VPC
resource "aws_vpc" "main" {
    cidr_block          =  var.vpc_cidr
    enable_dns_support  = true
    tags = {
        Name = "${var.project}-vpc"
    }
}

# This will create Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# This will create NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = element(aws_subnet.public[*].id, 0)
  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    Name = "${var.project}-nat-gateway"
  }
}

# This will create aws_subnet public
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-${count.index + 1}"
  }
}

# This will create the aws_subnet private
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-private-${count.index + 1}"
  }
}

# This will create the route table for public
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-public-rt"
  }
}

# This will give internet to route table for public
resource "aws_route" "internet_access" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# This will associate route table for public
resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


# This will crete route table for private
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-private-rt"
  }
}

# This will give internet to route table for private
resource "aws_route" "nat_route" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# This will create route table for private
resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Elastic IP code.
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-eip"
  }
}