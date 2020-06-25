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

resource "google_compute_firewall" "allow_http" {
  name    = "terraform-allow-http"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["web"]
}

# Specific IP ranges for the health checks
# https://cloud.google.com/load-balancing/docs/health-checks
resource "google_compute_firewall" "allow_health_checks" {
  name    = "terraform-allow-health-checks"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags = ["web"]
}

