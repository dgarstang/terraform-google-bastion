resource "google_compute_address" "bastion_public_ip" {
  name         = "bastion-public-ip"
  network_tier = "STANDARD"
  region       = var.region
}

resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = var.machine_type
  zone         = var.zone
  can_ip_forward = true
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

  metadata = merge(
    {
      ssh-keys = var.ssh_public_key
    },
    var.enable_vpn ? {
      startup-script = <<-EOT
        #!/bin/bash
        apt-get update
        apt-get install -y wireguard

        umask 077
        echo "${wireguard_asymmetric_key.key[0].private_key}" > /etc/wireguard/privatekey
        echo "${wireguard_asymmetric_key.key[0].public_key}" > /etc/wireguard/publickey
        chmod 600 /etc/wireguard/privatekey /etc/wireguard/publickey

        systemctl stop wg-quick@wg0

        cat <<EOF > /etc/wireguard/wg0.conf
        [Interface]
        Address = ${var.vpn_interface_cidr}
        ListenPort = ${var.vpn_interface_listen_port}
        PrivateKey = ${wireguard_asymmetric_key.key[0].private_key}
        SaveConfig = false

        PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens4 -s 10.0.0.0/24 -j MASQUERADE
        PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens4 -s 10.0.0.0/24 -j MASQUERADE

        [Peer]
        PublicKey = ${var.vpn_client_public_key}
        AllowedIPs = ${var.vpn_client_allowed_ips}
        EOF

        sysctl -w net.ipv4.ip_forward=1
        echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

        systemctl enable wg-quick@wg0
        systemctl start wg-quick@wg0
      EOT
    } : {}
  )
}

