resource "google_compute_address" "bastion_public_ip" {
  name         = "bastion-public-ip"
  network_tier = "STANDARD"
  region       = var.region
}

resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = "e2-micro"
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
  tags = ["allow-ssh"]
  metadata = {
    ssh-keys = var.ssh_public_key
  }
}
