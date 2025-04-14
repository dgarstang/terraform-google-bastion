resource "google_compute_address" "bastion_public_ip" {
  name         = "bastion-public-ip"
  network_tier = "STANDARD"
  region       = var.region
}

resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork = var.subnet_id
    access_config {
      nat_ip       = google_compute_address.bastion_public_ip.address
      network_tier = "STANDARD"
    }
  }
  tags = ["allow-ssh", "wireguard"]
  metadata = {
    ssh-keys = var.ssh_public_key
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
  EOT

}
