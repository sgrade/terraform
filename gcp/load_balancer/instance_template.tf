// https://www.terraform.io/docs/providers/google/r/compute_instance_template.html

resource "google_compute_instance_template" "instance_template_1" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  machine_type = var.instance_types[var.environment]
  instance_description = "description assigned to instances"
  tags = ["web"]
  labels = {
    environment = var.environment
  }

  can_ip_forward       = false

  // Create a new boot disk from an image
  disk {
    source_image = var.instance_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
      // Ephemeral IP
    }
  }
  
  metadata_startup_script = var.startup_script_apache

  service_account {
    scopes = ["cloud-platform"]
  }
}
