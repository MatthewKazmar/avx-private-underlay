variable "circuit" {
  type = object({
    circuit_name                   = string,
    cloud_type                     = number,
    vpc_id                         = string,
    vpc_cidr                       = optional(string, ""),
    subnet_id                      = optional(string, ""),
    azure_vnet_gateway_subnet_cidr = optional(string),
    azure_exr_use_2nd_location     = optional(bool, false),
    csp_region                     = string
    equinix_metrocode              = string,
    speed_in_mbit                  = string,
    edge_uuid                      = optional(list(string), [null, null]),
    edge_interface                 = optional(list(number), [null, null]),
    metal_service_tokens           = optional(list(string), [null, null]),
    equinix_side_asn               = number,
    vpc_asn                        = optional(number, 64512),
    bgp_auth_key                   = optional(string, "aviatrix1234#!"),
    notifications                  = list(string)
  })
}

locals {
  is_redundant = {
    #is_redundant = length(compact(var.circuit["edge_uuid"])) == 2 || length(compact(var.circuit["metal_service_tokens"])) == 2 ? true : false
    is_redundant = length(compact(var.circuit["metal_service_tokens"])) == 2 ? true : false
  }

  circuit = merge(var.circuit, local.is_redundant)

  cloud_map = {
    "1" = "aws",
    "8" = "azure",
    "4" = "gcp"
  }
}