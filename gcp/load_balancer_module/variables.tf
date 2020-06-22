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

######
# MIG

variable "target_size" {
  type    = number
  default = 2
}

variable "network_prefix" {
  type    = string
  default = "multi-mig-lb-http"
}

variable "test_service_account" {
  type = object({
    email  = string,
    scopes = list(string)
  })
  default = {
    email  = ""
    scopes = ["cloud-platform"]
  }
}
