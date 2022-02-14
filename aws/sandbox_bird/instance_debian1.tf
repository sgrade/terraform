// 

resource "aws_instance" "debian1" {
  ami                     = data.aws_ami.debian-11-amd64.id
  instance_type           = var.ec2_instance_type
  subnet_id               = aws_subnet.sandbox_public_subnet_1.id
  vpc_security_group_ids  = [aws_security_group.sandbox_sg.id]
  key_name                = var.key_name

  tags = var.resource_tags
}

resource "aws_network_interface" "private_subnet_1-11" {
  subnet_id = aws_subnet.sandbox_private_subnet_1.id

  // The first four IP addresses and the last IP address in each subnet CIDR block are reserved
  // https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#VPC_Sizing
  // private_ips = [cidrhost(var.private_subnet_cidr_blocks[0], 11)]
  private_ips = [cidrhost(aws_subnet.sandbox_private_subnet_1.cidr_block, 11)]

  tags = var.resource_tags
}

resource "aws_network_interface_attachment" "debian1_private_subnet_1_attachment" {
  instance_id          = aws_instance.debian1.id
  network_interface_id = aws_network_interface.private_subnet_1-11.id

  // IP addresses per network interface per instance type
  // https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
  device_index         = 1
}