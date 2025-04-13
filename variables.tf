variable "region" {
  description = "The region where the bastion host will be created."
  type        = string
  # No default, must be provided.
}

variable "zone" {
  description = "The zone where the bastion host will be created."
  type        = string
  # No default, must be provided.
}

variable "subnet_id" {
  description = "The ID of the subnetwork where the bastion host will be located."
  type        = string
  # No default, must be provided.
}

variable "ssh_public_key" {
  description = "Your SSH public key to access the bastion host."
  type        = string
  # No default, must be provided.
}

variable "network_name" {
  description = "The name of the network where the firewall will be created"
  type        = string
  # No default, must be provided
}
