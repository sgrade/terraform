// Reusable parts for the instances

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

