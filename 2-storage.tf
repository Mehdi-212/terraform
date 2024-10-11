resource "google_storage_bucket" "bronze_csv" {
  name     = "${var.project_id}-bronze-csv"  # Nom unique basé sur l'ID du projet
  location = var.region
  project  = var.project_id
}

resource "google_storage_bucket" "silver_parquet" {
  name     = "${var.project_id}-silver-parquet"  # Nom unique basé sur l'ID du projet
  location = var.region
  project  = var.project_id
}

resource "google_storage_bucket_object" "csv_to_parquet_function" {
  name   = "csv-to-parquet.zip"                                 
  bucket = google_storage_bucket.bronze_csv.name
  source = "cloud-functions-files/csv-to-parquet.zip"
}
