resource "google_compute_instance" "vm_instance_1" {
  name         = "terraform-instance-1"
  machine_type = var.instance_types[var.environment]
  zone = var.zone1
  labels         = {"environment": var.environment}

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_1.self_link
  }

}

resource "google_compute_instance" "vm_instance_2" {
  name         = "terraform-instance-2"
  machine_type = var.instance_types[var.environment]
  zone = var.zone2
  labels         = {"environment": var.environment}

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_2.self_link
  }

}
