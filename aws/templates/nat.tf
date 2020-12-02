// DOESN'T WORK YET
resource "aws_eip" "sandbox_nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "sandbox_nat_gateway" {
  allocation_id = aws_eip.sandbox_nat_gateway.id
  subnet_id     = aws_subnet.sandbox_public_subnet_1.id
  tags = var.resource_tags
}

output "nat_gateway_ip" {
  value = aws_eip.sandbox_nat_gateway.public_ip
}

resource "aws_route" "sandbox_default" {
  route_table_id            = aws_vpc.sandbox_vpc.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.sandbox_nat_gateway.id
}
