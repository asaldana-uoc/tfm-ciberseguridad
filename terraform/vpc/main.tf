resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = format("%s-vpc", var.resources_name)
  }
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = format("%s-vpc-default-security-group", var.resources_name)
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name = format("%s-vpc-default-route-table", var.resources_name)
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = format("%s-internet-gateway", var.resources_name)
  }
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  tags = {
    Name = format("%s-eip-nat-gateway", var.resources_name)
  }
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = element([for subnet in aws_subnet.private : subnet.id], 0)

  tags = {
    Name = format("%s-nat-gateway", var.resources_name)
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  cidr_block              = each.value.cidr_block
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.name
  map_public_ip_on_launch = try(each.value.public_ip_on_launch, true)

  tags = {
    Name = format("%s-public-subnet-%s", var.resources_name, each.value.name)
    Type = "public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = format("%s-public-route-table", var.resources_name)
  }
}

resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  cidr_block        = each.value.cidr_block
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.name

  tags = {
    Name = format("%s-private-subnet-%s", var.resources_name, each.value.name)
    Type = "private"
  }
}

resource "aws_route_table" "private" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = format("%s-private-route-table", var.resources_name)
  }
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[0].id
}