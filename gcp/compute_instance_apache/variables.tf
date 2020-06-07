variable "project" { }

variable "credentials_file" { }

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "machine_types" {
  type    = map
  default = {
    dev  = "f1-micro"
    test = "n1-highcpu-32"
    prod = "n1-highcpu-32"
  }
}

variable "startup_script_apache" {
  type = string
  default = <<EOF
  #! /bin/bash
  apt-get update
  apt-get install -y apache2
  cat <<EOF > /var/www/html/index.html
  <html><body><h1>Hello World</h1>
  <p>This page was created from a simple startup script!</p>
  </body></html>
  EOF
}

