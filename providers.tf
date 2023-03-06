terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "~> 3.0.0"
    }
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
      configuration_aliases = [ aws.east, aws.west ]
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.30.0"
    }
  }
}