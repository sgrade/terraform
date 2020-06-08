provider "google" {

  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_firewall" "default" {
  name    = "terraform-firewall"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  target_tags = ["web"]
}

module "tf_instance_1" {
  source              = "./modules/compute_instance_apache"
  instance_name       = "tf-instance-1"
  vpc_network = google_compute_network.vpc_network.self_link
}

module "tf_instance_2" {
  source              = "./modules/compute_instance_apache"
  instance_name       = "tf-instance-2"
  vpc_network = google_compute_network.vpc_network.self_link
}

resource "google_compute_instance_group" "terraform_group" {
  name = "terraform-group"
  network = google_compute_network.vpc_network.self_link
  instances = [
    module.tf_instance_1.self_link,
    module.tf_instance_2.self_link, 
  ]
  named_port {
    name = "http"
    port = "80"
  }
  named_port {
    name = "https"
    port = "443"
  }
}
