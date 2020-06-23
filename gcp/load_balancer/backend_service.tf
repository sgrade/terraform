resource "google_compute_health_check" "health_check_1" {
  name         = "tf-health"
  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = var.service_port
  }
}

resource "google_compute_backend_service" "backend_service_1" {
  name      = "tf-backend"
  port_name = var.service_port_name
  protocol  = var.protocol

  backend {
    group = google_compute_instance_group_manager.instance_group_manager_1.instance_group
  }

  health_checks = [
    google_compute_health_check.health_check_1.id,
  ]
}
