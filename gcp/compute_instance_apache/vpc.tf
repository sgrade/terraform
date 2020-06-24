resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
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