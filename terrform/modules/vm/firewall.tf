resource "google_compute_firewall" "http" {
  name    = "http"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["webapp"]
  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "postgresql" {
  name    = "postgresql"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  target_tags   = ["database"]
  source_ranges = ["0.0.0.0/0"]
}