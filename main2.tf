provider "google" {
  project = var.project_id
  region  = var.region
}
# ✅ Artifact Registry for storing Docker images
resource "google_artifact_registry_repository" "repo" {
  provider      = google
  location      = var.region
  repository_id = "my-docker-repo" 
  format        = "DOCKER"
}
