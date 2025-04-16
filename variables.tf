variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "e2-micro"
}

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

variable "vpn_client_public_key" {
  type = string
}

variable "enable_vpn" {
  type    = bool
  default = true
}

variable "vpn_interface_cidr" {
  type = string
  default = "10.0.0.1/24"
}

variable "vpn_client_allowed_ips" {
    type = string
  default = "10.0.0.2/32" #, 172.16.0.0/28"
}

variable "vpn_interface_listen_port" {
  type = number
  default = 51820
}
