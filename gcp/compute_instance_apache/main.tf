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
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = var.startup_script_apache

}

resource "google_compute_firewall" "allow_icmp" {
  name    = "terraform-allow-icmp"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "icmp"
  }

}

resource "google_compute_firewall" "allow_ssh" {
  name    = "terraform-allow-ssh"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "terraform-allow-http-https"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags = ["web"]
}
