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
  source              = "../compute_instance_apache"
  instance_name       = "tf-instance-1"
  vpc_network = google_compute_network.vpc_network.self_link
}

module "tf_instance_2" {
  source              = "../compute_instance_apache"
  instance_name       = "tf-instance-2"
  vpc_network = google_compute_network.vpc_network.self_link
}

resource "google_compute_instance_group" "tf_group" {
  name = "tf-group"
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

resource "google_compute_health_check" "tf_health_check" {
  name         = "tf-health"
  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "tf_backend" {
  name      = "tf-backend"
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = google_compute_instance_group.tf_group.id
  }

  health_checks = [
    google_compute_health_check.tf_health_check.id,
  ]
}
