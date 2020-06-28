resource "google_compute_network" "vpc_network" {
  name = "vpc-network"

  # By default terraform creates VPC in auto mode. Set to false for custom mode.
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "subnet_1" {
  name          = "test-subnetwork-1"
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region1
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_2" {
  name          = "test-subnetwork-2"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region2
  network       = google_compute_network.vpc_network.id
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
