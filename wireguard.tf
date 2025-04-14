resource "wireguard_asymmetric_key" "key" {
}

output "wg_public_key" {
  description = "Public WireGuard key"
  value       = wireguard_asymmetric_key.key.public_key
}

output "wg_private_key" {
  description = "Private WireGuard key"
  value       = wireguard_asymmetric_key.key.private_key
  sensitive   = true
}
