module "vpc" {
  source              = "./modules/vpc"
}

module "mig1_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  #version              = "1.0.0"
  network              = module.vpc.vpc_network
  #subnetwork           = google_compute_subnetwork.group1.self_link
  service_account      = var.test_service_account
  #name_prefix          = "${var.network_prefix}-group1"
  #startup_script       = data.template_file.group-startup-script.rendered
  #source_image_family  = "ubuntu-1804-lts"
  #source_image_project = "ubuntu-os-cloud"
  #tags = [
  #  "${var.network_prefix}-group1",
  #  module.cloud-nat-group1.router_name
  #]
}

module "mig1" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  #version           = "1.0.0"
  instance_template = module.mig1_template.self_link
  region            = var.region
  hostname          = "${var.network_prefix}-group1"
  target_size       = var.target_size
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = module.vpc.vpc_network
  #subnetwork = google_compute_subnetwork.group1.self_link
}
