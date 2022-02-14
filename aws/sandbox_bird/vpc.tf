resource "aws_vpc" "sandbox_vpc" {
  cidr_block            = var.vpc_cidr_block
  instance_tenancy      = "default"
  // True so, instances are accessible from Internet
  enable_dns_hostnames  = true

  tags = var.resource_tags
}

// +++++++++++++++++++
// Private networks

resource "aws_subnet" "sandbox_private_subnet_1" {
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[0]
  // False, so instances are not accessible from Internet
  map_public_ip_on_launch = false

  tags = var.resource_tags
}

// +++++++++++++++++++
// Internet access

resource "aws_internet_gateway" "sandbox_gw" {
  vpc_id = aws_vpc.sandbox_vpc.id
  tags = var.resource_tags
}

resource "aws_subnet" "sandbox_public_subnet_1" {
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[0]
  // True, so instances are accessible from Internet
  map_public_ip_on_launch = true
  tags = var.resource_tags
}

resource "aws_route_table" "sandbox_public" {
  vpc_id = aws_vpc.sandbox_vpc.id
  tags = var.resource_tags
}

// Subnets that are not explicitely associated with some subnet will be associated with main route table
resource "aws_route_table_association" "sandbox_public" {
  subnet_id      = aws_subnet.sandbox_public_subnet_1.id
  route_table_id = aws_route_table.sandbox_public.id
}

resource "aws_route" "sandbox_public_subnet_to_internet" {
  destination_cidr_block    = "0.0.0.0/0"
  route_table_id            = aws_route_table.sandbox_public.id
  gateway_id                = aws_internet_gateway.sandbox_gw.id
}

resource "aws_route" "sandbox_main_rt_to_debian1" {
  destination_cidr_block    = "0.0.0.0/0"
  route_table_id            = aws_vpc.sandbox_vpc.main_route_table_id
  instance_id                = aws_instance.debian1.id
}
