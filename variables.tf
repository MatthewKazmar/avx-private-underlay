variable "circuit" {
  type = object({
    is_redundant         = bool,
    cloud_type           = number,
    circuit_name         = string,
    vpc_id               = string,
    csp_region           = string,
    equinix_metrocode    = string,
    speed                = string,
    edge_uuid            = optional(list(string), [null, null]),
    edge_interface       = optional(number, null),
    metal_service_tokens = optional(list(string), [null, null]),
    customer_side_asn    = number,
    vpc_asn              = optional(number, 64512),
    bgp_auth_key         = optional(string, "aviatrix1234#!"),
    notifications        = list(string),
    #AWS
    transit_subnet_cidrs = optional(list(string)),
    #Azure
    azure_vnet_gateway_subnet_cidr = optional(string, null),
    azure_exr_use_2nd_location     = optional(bool, false),
  })
}

locals {
  # Only one module is valid, lets grab the right output.
  module_output = try(coalesce(one(module.directconnect), one(module.expressroute), one(module.cloudinterconnect)), {})
}