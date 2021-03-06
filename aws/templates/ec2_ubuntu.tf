// Test host in the sandbox VPC
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

  tags = var.resource_tags
}

resource "aws_instance" "sandbox_host" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.ec2_instance_type
  subnet_id               = aws_subnet.sandbox_private_subnet_1.id
  vpc_security_group_ids  = [aws_security_group.sandbox_sg.id]
  key_name                = var.key_name

  tags              = var.resource_tags
}
