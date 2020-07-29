provider "google" {
  credentials = file(var.service_account)
  project     = var.project_id
  region      = var.region
}


module "vm" {
  source                       = "./vm"
  machine_type                 = "n1-standard-1"
  region                       = var.region
  zone                         = "us-east4-a"
  webapp_count                 = 1
  ssh_public_key_filepath      = var.ssh_public_key_filepath
  network                      = "default"
}