resource "aws_vpc" "sandbox_vpc" {
  cidr_block            = var.vpc_cidr_block
  instance_tenancy      = "default"
  // True so, instances are accessible from Internet
  enable_dns_hostnames  = true
  tags = var.resource_tags
}

resource "aws_subnet" "sandbox_private_subnet_1" {
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[0]
  // False, so instances are not accessible from Internet
  map_public_ip_on_launch = false
  tags = var.resource_tags
}

data "aws_vpc" "peer" {
  id = var.peer_vpc_id
}

data "aws_route_table" "peer_main" {
  vpc_id = var.peer_vpc_id
}

resource "aws_vpc_peering_connection" "sandbox_peering" {
  vpc_id            = aws_vpc.sandbox_vpc.id
  peer_vpc_id       = data.aws_vpc.peer.id
  auto_accept       = true
  tags = var.resource_tags
}

resource "aws_route" "peer_vpc_to_sandbox" {
  route_table_id            = data.aws_route_table.peer_main.id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sandbox_peering.id
}

resource "aws_route" "sandbox_to_peer_vpc" {
  route_table_id            = aws_vpc.sandbox_vpc.main_route_table_id
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sandbox_peering.id
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

resource "aws_route" "sandbox_main_rt_to_nat" {
  destination_cidr_block    = "0.0.0.0/0"
  route_table_id            = aws_vpc.sandbox_vpc.main_route_table_id
  instance_id                = aws_instance.sandbox_nat.id
}
