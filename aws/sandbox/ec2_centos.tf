// Test host in the sandbox VPC
// https://wiki.centos.org/Cloud/AWS

data "aws_ami" "centos_7_with_updates_hvm" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["cvugziknvmxgqna9noibqnnsy"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["aws-marketplace"]

  tags = var.resource_tags
}

resource "aws_instance" "sandbox_centos_7" {
  ami                     = data.aws_ami.centos_7_with_updates_hvm.id
  instance_type           = var.ec2_instance_type
  subnet_id               = aws_subnet.sandbox_private_subnet_1.id
  vpc_security_group_ids  = [aws_security_group.sandbox_sg.id]
  key_name                = var.key_name

  user_data               = <<EOF
#cloud-config
cloud_final_modules:
- [users-groups,always]
users:
  - name: roman
    groups: [ wheel ]
    sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
    shell: /bin/bash
    ssh-authorized-keys: 
    - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDs7shf1gXPP6DwUiWQIiI3wdrnTx/4/lxD3cWr/wVyNJeiyBsN/HOxAQVe1k7LYU6Klt1tsF98AgAeKeE/9s/HmgAOQJLdhLlDk4Tvs7jMDwvwdvCj/rJoIIen1vdsYF44KlWarUVDJikR8TPSS/vRL5xp+rnztaWQWPezxYi0uXCZEuqqHNXt3GzlEHs1m1NAyUPTjc0HuX3ASiXsbD4MQtQxdVOwLwX/0JdqQkcdf97BjhBfmH0sBRXPZcPK694r5l5wK6W2pxZJEs+phDfvUUXtxhVj/N6G38yA3mDlwhG1jO3TKfL3LMMV7wlOMm7qIEWMRoekI0n+ea+olrRJQX+lG7Ww4Fcsayl1Un6hMHOgXXzpZnODFPp96NooDXoditnqhejWArSOREkNk4n6BCqDoiz9PVyisaX/idwh3AeJ8rowsjx41f2D08s8BKhf3Z9eSbXW5R/pp1ZONzCaB50NUVk1J8bZzpLDeGNKoeh/O3zvKYEik+euK6zaiTU= roman@dev
  EOF

  tags              = var.resource_tags
}
