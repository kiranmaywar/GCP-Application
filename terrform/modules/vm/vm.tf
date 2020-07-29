resource "google_compute_instance_template" "webapp" {
  name         = "webapp-instance-template"
  machine_type = var.machine_type
  region       = var.region

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_filepath)}"
  }

  disk {
    source_image = "ubuntu-1804-bionic-v20200716"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network            = var.network
    access_config {
      # Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

  tags = ["webapp"]

}


resource "google_compute_instance" "database" {
  name           = "postgres"
  machine_type   = var.machine_type
  zone           = var.zone

  tags = ["database"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20200716"
    }
  }

  network_interface {
    network = var.network

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    sshKeys = "ubuntu:${file(var.ssh_public_key_filepath)}"
  }
}