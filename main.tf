terraform {
  required_version = ">= 0.12.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

locals {
  selector_labels = {
    "app.kubernetes.io/name" = "zerotier-haproxy-${var.name}"
  }
}