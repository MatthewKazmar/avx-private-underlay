terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.12.0"
    }
    google = {
      source = "hashicorp/google"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.37.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.30.0"
    }
  }
}