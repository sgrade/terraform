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

