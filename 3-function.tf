resource "google_cloudfunctions2_function" "function" {
  name     = "csv_to_parquet_function"
  location = var.region
  project  = var.project_id  # Ajoute l'ID du projet ici

  build_config {
    runtime     = "python310"
    entry_point = "hello_gcs"
    source {
      storage_source {
        bucket = google_storage_bucket.bronze_csv.name
        object = google_storage_bucket_object.csv_to_parquet_function.name
      }
    }
  }

  service_config {
    available_memory = "1Gi"  # Spécifie 1 Go de mémoire
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    trigger_region = var.region
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.bronze_csv.name
    }
  }
}
