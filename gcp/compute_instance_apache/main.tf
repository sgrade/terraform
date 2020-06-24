resource "google_compute_instance" "compute_instance" {
  name         = "tf-instance-1"
  machine_type = var.instance_types[var.environment]
  tags         = ["web"]

  boot_disk {
    initialize_params {
      image = var.instance_image
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
