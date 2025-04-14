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
    apt-get install -y wireguard

    umask 077
    wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey

    PRIVATE_KEY=$(cat /etc/wireguard/privatekey)

    systemctl stop wg-quick@wg0

    cat <<EOF > /etc/wireguard/wg0.conf
    [Interface]
    Address = 10.0.0.1/24
    ListenPort = 51820
    PrivateKey = $PRIVATE_KEY
    SaveConfig = false

    [Peer]
    PublicKey = rkysLZbnTa6mJOzeabZuF8fL8uiKWpkXUXx/tgdSEWM=
    AllowedIPs = 10.0.0.2/32
    EOF

    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0
  EOT

}
