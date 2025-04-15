resource "wireguard_asymmetric_key" "key" {
  count = var.enable_vpn ? 1 : 0
}

output "wg_public_key" {
  description = "Public WireGuard key"
  value       = wireguard_asymmetric_key.key[0].public_key
}

output "wg_private_key" {
  description = "Private WireGuard key"
  value       = wireguard_asymmetric_key.key[0].private_key
  sensitive   = true
}
