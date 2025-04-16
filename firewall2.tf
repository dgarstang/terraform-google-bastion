resource "google_compute_firewall" "control_plane_to_nodes" {
  name          = "allow-control-plane-to-nodes"
  network       = var.network_name
  direction     = "INGRESS"
  source_ranges = [
    "35.191.0.0/16", 
    "130.211.0.0/22", 
    "172.16.0.0/28"  # Adding control plane's private range
  ]
  priority      = 1000
  allow {
    protocol = "tcp"
    ports    = ["443", "10250", "8443"]
  }
  allow {
    protocol = "udp"
    ports    = ["8472"]
  }
  allow {
    protocol = "icmp"
  }
  description = "Allow GKE control plane to communicate with nodes"
}

resource "google_compute_firewall" "nodes_to_control_plane" {
  name               = "allow-nodes-to-control-plane"
  network            = var.network_name
  direction          = "EGRESS"
  destination_ranges = ["172.16.0.0/28"]  # Adjusting to control plane's actual IP range
  priority           = 1000
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  description = "Allow nodes to reach the GKE control plane over private IP"
}

resource "google_compute_firewall" "node_to_node" {
  name          = "allow-node-to-node"
  network       = var.network_name
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["10.0.0.0/8"]
  allow {
    protocol = "all"
  }
  description = "Allow all traffic between GKE nodes"
}

resource "google_compute_firewall" "node_egress_internet" {
  name               = "allow-node-egress-internet"
  network            = var.network_name
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority           = 1000
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  allow {
    protocol = "udp"
    ports    = ["53"]
  }
  allow {
    protocol = "tcp"
    ports    = ["53"]
  }
  description = "Allow GKE nodes to access internet"
}

