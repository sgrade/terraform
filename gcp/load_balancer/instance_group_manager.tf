resource "google_compute_instance_group_manager" "instance_group_manager_1" {
  name               = "instance-group-1"

  base_instance_name = "instance-group-1"

  version {
    name              = "appserver"
    instance_template = google_compute_instance_template.instance_template_1.id
  }

  zone               = var.zone
  target_size        = "2"

  named_port {
    name = var.service_port_name
    port = var.service_port
  }
}

