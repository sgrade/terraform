resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg"
  description = "Sandbox security group"
  vpc_id      = aws_vpc.sandbox_vpc.id

  tags = var.resource_tags
}

resource "aws_security_group_rule" "allow_ssh_peer_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.peer_vpc.cidr_block]
  security_group_id = aws_security_group.sandbox_sg.id
}

resource "aws_security_group_rule" "allow_icmp_peer_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = [data.aws_vpc.peer_vpc.cidr_block]
  security_group_id = aws_security_group.sandbox_sg.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sandbox_sg.id
}
