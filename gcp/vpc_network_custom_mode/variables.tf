variable "project" { }

variable "credentials_file" { }

variable "region1" {
  default = "us-central1"
}

variable "zone1" {
  default = "us-central1-c"
}

variable "region2" {
  default = "us-east1"
}

variable "zone2" {
  default = "us-east1-c"
}

variable "environment" {
  type    = string
  default = "dev"
}

# variable "instance_name" {}

variable "instance_types" {
  type    = map
  default = {
    dev  = "f1-micro"
    test = "n1-highcpu-32"
    prod = "n1-highcpu-32"
  }
}

variable "instance_image" {
  default = "debian-cloud/debian-10"
}
