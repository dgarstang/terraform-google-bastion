terraform {
  required_version = ">= 1.11.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    wireguard = {
      source = "ojford/wireguard"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
