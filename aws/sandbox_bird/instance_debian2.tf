// 

resource "aws_instance" "debian2" {
  ami                     = data.aws_ami.debian-11-amd64.id
  instance_type           = var.ec2_instance_type
  subnet_id               = aws_subnet.sandbox_public_subnet_1.id
  vpc_security_group_ids  = [aws_security_group.sandbox_sg.id]
  key_name                = var.key_name

  tags = var.resource_tags
}

resource "aws_network_interface" "private_subnet_1-12" {
  subnet_id   = aws_subnet.sandbox_private_subnet_1.id
  
  // The first four IP addresses and the last IP address in each subnet CIDR block are reserved
  // https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#VPC_Sizing
  private_ips = [cidrhost(aws_subnet.sandbox_private_subnet_1.cidr_block, 12)]

  tags = var.resource_tags
}

resource "aws_network_interface_attachment" "debian2_private_subnet_1_attachment" {
  instance_id          = aws_instance.debian2.id
  network_interface_id = aws_network_interface.private_subnet_1-12.id
  
  // IP addresses per network interface per instance type
  // https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
  device_index         = 1
}