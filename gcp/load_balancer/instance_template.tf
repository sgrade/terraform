// https://www.terraform.io/docs/providers/google/r/compute_instance_template.html

resource "google_compute_instance_template" "instance_template_1" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["web"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "n1-standard-1"
  can_ip_forward       = false

  // Create a new boot disk from an image
  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}
