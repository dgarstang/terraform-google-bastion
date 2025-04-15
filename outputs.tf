output "bastion_public_ip" {
  description = "Public IP address of the bastion instance"
  value = google_compute_address.bastion_public_ip.address
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion instance"
  value       = google_compute_instance.bastion.network_interface[0].network_ip
}
