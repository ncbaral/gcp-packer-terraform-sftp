variable "name" {}

variable "project" {}

variable "region" {}

variable "sftp_disk_image" {}

data "template_file" "pub_key" {
    template = "${file("~/.ssh/id_rsa.pub")}"
}

terraform {
    required_version = "> 0.9.0"
}

provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.1.0"
}

resource "google_compute_instance" "sftp" {
  name         = "${var.name}"
  machine_type = "g1-small"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/${var.project}/global/images/family/${var.sftp_disk_image}"
    }
  }

  network_interface {
    network = "default"
    
    access_config {}
  }

  
}

resource "google_compute_project_metadata" "metadata" {
  metadata {
    ssh-keys                       = "${data.template_file.pub_key.rendered}"
  }
}