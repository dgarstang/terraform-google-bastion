variable "region" {
  description = "The region where the bastion host will be created."
  type        = string
}

variable "zone" {
  description = "The zone where the bastion host will be created."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnetwork where the bastion host will be located."
  type        = string
}

variable "ssh_public_key" {
  description = "Your SSH public key to access the bastion host."
  type        = string
}

variable "network_name" {
  description = "The name of the network where the firewall will be created"
  type        = string
}
