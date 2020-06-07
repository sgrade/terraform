resource "google_compute_instance" "compute_instance" {
  name         = var.instance_name
  machine_type = var.instance_types[var.environment]
  tags         = ["web"]

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    network = var.vpc_network
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = var.startup_script_apache

}
