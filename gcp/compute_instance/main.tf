provider "google" {

  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance_1" {
  name         = "terraform-instance-1"
  machine_type = var.machine_types[var.environment]
  tags         = ["web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
  }

}

resource "google_compute_firewall" "default" {
  name    = "terraform-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  target_tags = ["web"]
}
