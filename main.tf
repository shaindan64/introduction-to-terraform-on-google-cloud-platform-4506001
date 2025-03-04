resource "google_compute_network" "app" {
  name                    = "app-network"
  auto_create_subnetworks  = false
}

resource "google_compute_subnetwork" "app" {
  name          = "app-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-west1"  # Specify the region, not the availability zone
  network       = google_compute_network.app.id  # Correct network reference
}

data "google_compute_image" "ubuntu" {
  most_recent = true
  project     = "ubuntu-os-cloud"
  family      = "ubuntu-2204-lts"
}

resource "google_compute_instance" "web" {
  name         = "web"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app.id  # Use subnetwork reference
    access_config {
      # Leave empty for dynamic public IP
    }
  }

 allow_stopping_for_update = true 
}
