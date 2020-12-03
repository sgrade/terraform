resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg"
  description = "Sandbox security group"
  vpc_id      = aws_vpc.sandbox_vpc.id

  tags = var.resource_tags
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sandbox_sg.id
}

resource "aws_security_group_rule" "allow_ssh_ec2_instance_connect" {
  description       = "EC2_INSTANCE_CONNECT"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["3.120.181.40/29"]
  security_group_id = aws_security_group.sandbox_sg.id
}

resource "aws_security_group_rule" "allow_ssh_from_peer_vpc" {
  description       = "Peer VPC to Sandbox VPC"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.peer.cidr_block]
  security_group_id = aws_security_group.sandbox_sg.id
}

resource "aws_security_group_rule" "allow_icmp_from_peer_vpc" {
  description       = "Peer VPC to Sandbox VPC"
  type              = "ingress"
  // Echo request
  from_port         = 8
  to_port           = 8
  protocol          = "icmp"
  cidr_blocks       = [data.aws_vpc.peer.cidr_block]
  security_group_id = aws_security_group.sandbox_sg.id
}

// https://discuss.hashicorp.com/t/querying-aws-default-security-group-id-without-creating/5196/2
data "aws_security_group" "peer_vpc_default_sg" {
  vpc_id = data.aws_vpc.peer.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_security_group_rule" "allow_icmp_from_sandbox_vpc" {
  description       = "Sandbox VPC to Peer VPC"
  type              = "ingress"
  // Echo request
  from_port         = 8
  to_port           = 8
  protocol          = "icmp"
  cidr_blocks       = [aws_vpc.sandbox_vpc.cidr_block]
  // TODO: replace default security group with bastion host security group
  security_group_id = data.aws_security_group.peer_vpc_default_sg.id
}
