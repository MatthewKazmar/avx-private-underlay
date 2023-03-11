variable "circuit" {
  type = object({
    is_redundant                   = bool,
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
  network = split("~-~", var.circuit["vpc_id"])[0]

  #Aviatrix GCP Gateway lists the zone in the vpc_reg attribute.
  csp_region = regex("[a-z]+-[a-z0-9]+", var.circuit["csp_region"])
}