resource "aws_vpc" "sandbox_vpc" {
  cidr_block            = var.vpc_cidr_block
  instance_tenancy      = "default"
  // False, so, instances are not accessible from Internet
  enable_dns_hostnames  = false
 
  tags = var.resource_tags
}

resource "aws_subnet" "sandbox_private_subnet_1" {
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = "10.0.1.0/24"
  // False, so, instances are not accessible from Internet
  map_public_ip_on_launch = false

  tags = var.resource_tags
}

/*
// Subnets that are not explicitely associated with some subnet will be associated with main route table
resource "aws_route_table_association" "sandbox_private_subnet_1" {
  subnet_id      = aws_subnet.sandbox_private_subnet_1.id
  route_table_id = aws_vpc.sandbox_vpc.main_route_table_id
}
*/

data "aws_vpc" "peer_vpc" {
  id = var.peer_vpc_id
}

data "aws_route_table" "peer_main_rt" {
  vpc_id = var.peer_vpc_id
}

resource "aws_vpc_peering_connection" "sandbox_peering" {
  vpc_id            = aws_vpc.sandbox_vpc.id
  peer_vpc_id       = data.aws_vpc.peer_vpc.id
  auto_accept       = true

  tags = var.resource_tags
}

resource "aws_route" "peer_vpc_to_sandbox_route" {
  route_table_id            = data.aws_route_table.peer_main_rt.id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sandbox_peering.id
}

resource "aws_route" "sandbox_to_peer_vpc_route" {
  route_table_id            = aws_vpc.sandbox_vpc.main_route_table_id
  destination_cidr_block    = data.aws_vpc.peer_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sandbox_peering.id
}
