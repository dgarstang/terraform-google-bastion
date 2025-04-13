/*
resource "google_compute_firewall" "allow_ssh_from_iap" {
  name    = "allow-ssh-from-iap"
  network = var.network_name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-ssh"]
}
*/

resource "google_compute_firewall" "delete_default_ingress" {
  name    = "ingress-from-home"
  network = var.network_name
  lifecycle {
    create_before_destroy = true
  }
  allow { # Add an empty allow block.  This is required, but won't allow any traffic
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["202.92.122.131/32"]
    target_tags   = ["allow-ssh"]
}
