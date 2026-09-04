variable "project_id" { type=string description="GCP project ID" }
variable "region" { type=string default="us-central1" }
variable "container_image" { type=string description="Artifact Registry image URI" }
