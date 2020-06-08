variable "project" { }

variable "credentials_file" { }

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "service_port" {
  default = 80
}

variable "service_port_name" {
  default = "HTTP"
}