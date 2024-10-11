terraform {
  backend "gcs" {
    bucket = "terraform_bucket_auto"  
    prefix = "terraform/state"       
  }
}
