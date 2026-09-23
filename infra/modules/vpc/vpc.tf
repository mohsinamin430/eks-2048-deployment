resource "aws_vpc" "eks_2048_deployment" {
  cidr_block = var.vpc-cidr

  tags = var.tags
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_2048_deployment.id

  tags = var.tags
}

# Elastic IP for the NAT Gateway
resource "aws_eip" "eks_nat_eip" {
  count  = 2
  domain = "vpc"
}

# NAT Gateway for the VPC
resource "aws_nat_gateway" "eks_nat" {
  vpc_id            = aws_vpc.eks_2048_deployment.id
  availability_mode = "regional"
  availability_zone_address {
    availability_zone = "eu-west-2a"
    allocation_ids    = [aws_eip.eks_nat_eip[0].id]
  }
  availability_zone_address {
    availability_zone = "eu-west-2b"
    allocation_ids    = [aws_eip.eks_nat_eip[1].id]
  }
}


#For_each subnets
resource "aws_subnet" "eks_subnets" {
  for_each = var.subnets

  vpc_id            = aws_vpc.eks_2048_deployment.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(
    var.tags,
    {
      Name = each.key
    }
  )
}

# Route tables for the VPC
resource "aws_route_table" "public_table" {
  vpc_id = aws_vpc.eks_2048_deployment.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = var.tags
}

resource "aws_route_table" "private_table" {
  vpc_id = aws_vpc.eks_2048_deployment.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat.id
  }

  tags = var.tags
}

# Route table associations for the subnets

resource "aws_route_table_association" "public" {
  for_each = {
    for key, subnet in var.subnets :
    key => subnet
    if subnet.type == "public"
  }

  subnet_id      = aws_subnet.eks_subnets[each.key].id
  route_table_id = aws_route_table.public_table.id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for key, subnet in var.subnets :
    key => subnet
    if subnet.type == "private"
  }

  subnet_id      = aws_subnet.eks_subnets[each.key].id
  route_table_id = aws_route_table.private_table.id
}