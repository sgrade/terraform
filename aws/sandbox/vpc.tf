resource "aws_vpc" "sandbox_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
 
  tags = var.resource_tags
}

resource "aws_subnet" "sandbox_subnet_1" {
  vpc_id     = aws_vpc.sandbox_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = var.resource_tags
}

resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg"
  description = "Sandbox security group"
  vpc_id      = aws_vpc.sandbox_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.sandbox_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.resource_tags
}

resource "aws_vpc_peering_connection" "sandbox_peering" {
  // TODO: replace hardcoded with requet for default vpc 
  vpc_id            = aws_vpc.sandbox_vpc.id
  peer_vpc_id       = var.peer_vpc_id

  tags = var.resource_tags
}

resource "aws_route_table" "sandbox_default_rt" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = var.resource_tags
}

resource "aws_route" "sandbox_default_route" {
  route_table_id            = aws_route_table.sandbox_default_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  vpc_peering_connection_id = aws_vpc_peering_connection.sandbox_peering.id
  depends_on                = [aws_route_table.sandbox_default_rt]
}

resource "aws_route" "sandbox_to_peer_vpc_route" {
  route_table_id            = aws_route_table.sandbox_default_rt.id
  destination_cidr_block    = var.peer_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sandbox_peering.id
}

data "aws_route_table" "peer_main_rt" {
  vpc_id = var.peer_vpc_id
}

resource "aws_route" "peer_vpc_to_sandbox_route" {
  route_table_id            = data.aws_route_table.peer_main_rt.id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sandbox_peering.id
}
