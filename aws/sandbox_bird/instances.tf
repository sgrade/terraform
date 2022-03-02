// EC2 Instances

// Debian
// https://cloud.debian.org/images/cloud/
// https://wiki.debian.org/Cloud/AmazonEC2Image/Bullseye
// SSH to Debian instances as user admin using your SSH key, and then sudo -i to gain root access.
data "aws_ami" "debian-11-amd64" { 
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  owners = ["136693071363"]

  tags = var.resource_tags
}

// Virtual Machines to host BIRD
data "template_file" "user_data" {
  template = file("../scripts/bird.yaml")
}

resource "aws_instance" "router" {
  count                   = var.instance_count
  ami                     = data.aws_ami.debian-11-amd64.id
  instance_type           = var.ec2_instance_type
  subnet_id               = aws_subnet.sandbox_public_subnet_1.id
  vpc_security_group_ids  = [aws_security_group.sandbox_sg.id]
  key_name                = var.key_name

  user_data               = data.template_file.user_data.rendered

  tags = merge(
    {
      // First letter of the "Name" tag should be capital. 
      // Otherwise it will work as a tag, but won't show Name in AWS console
      Name = "router${count.index + 1}"
    },
    var.resource_tags
  )

  /*
  // Provisioner doesn't work yet. Need to configure connection: https://www.terraform.io/language/resources/provisioners/connection
  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname $router${count.index + 1}"]
  }
  */
}

// Other types
