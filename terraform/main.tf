provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_dataproc_cluster" "main" {
  name   = var.cluster_name
  region = var.region

  cluster_config {
    master_config {
      num_instances = 1
      machine_type  = "n2-standard-2"
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 200
      }
    }

    worker_config {
      num_instances = 2
      machine_type  = "n2-standard-2"
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 100
      }
    }

    software_config {
      image_version = "2.1-debian11"
      optional_components = ["HIVE_WEBHCAT", "JUPYTER", "ZEPPELIN", "ZOOKEEPER"]
    }

    endpoint_config {
      enable_http_port_access = "true"
    }
  }
}