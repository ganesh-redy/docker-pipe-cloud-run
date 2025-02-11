provider "google" {
  project = var.project_id
  region  = var.region
}

# ✅ Fix: Corrected `region` name
resource "google_compute_network" "net" {
  name                    = "network-off"
  auto_create_subnetworks = false
}

# ✅ Fix: Corrected `region` name
resource "google_compute_subnetwork" "sub1" {
  name          = "sub1"
  network       = google_compute_network.net.id
  ip_cidr_range = "10.0.0.0/20"
  region        = var.region  # Fix applied
}

# ✅ Fix: Corrected `source_ranges` syntax
resource "google_compute_firewall" "firewall1" {
  name    = "fire1"
  network = google_compute_network.net.id

  allow {
    protocol = "tcp"
    ports    = [443, 80, 8080, 5000]
  }

  source_ranges = ["0.0.0.0/0"]  # Fix applied
}

resource "google_compute_instance" "inst" {
  name         = "resource1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"  # Fix applied

  boot_disk {
    initialize_params {
      image = "centos-stream-9"
    }
  }

  network_interface {
    network    = google_compute_network.net.id
    subnetwork = google_compute_subnetwork.sub1.id
  }
}

# ✅ Fix: Added `zone` for disk attachment
resource "google_compute_disk" "disk" {
  name = "disk-pipe"
  size = 25
  zone = "us-central1-a"  # Fix applied
}

resource "google_compute_attached_disk" "att1" {
  disk     = google_compute_disk.disk.name
  instance = google_compute_instance.inst.name
  zone     = "us-central1-a"  # Fix applied
}


# ✅ Fix: Corrected Artifact Registry URL
resource "google_cloud_run_service" "cloud_run" {
  name     = var.image_name
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/my-docker-repo/${var.image_name}:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "all_users" {
  service  = google_cloud_run_service.cloud_run.name
  location = google_cloud_run_service.cloud_run.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "cloud_run_url" {
  value = google_cloud_run_service.cloud_run.status[0].url
}

# ✅ Fix: Corrected `region` values and `image_name` match with Jenkins
variable "project_id" {
  default = "mythic-inn-420620"
}

variable "image_name" {
  default = "docker-cloud"
}

variable "region" {
  default = "us-central1"
}
