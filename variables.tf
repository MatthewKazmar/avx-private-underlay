variable "circuit" {
  type = object({
    is_redundant = bool,
    circuit_name = string,
    transit_gw   = string,
    # cloud_type                     = number,
    # vpc_id                         = string,
    # csp_region                     = string,
    azure_vnet_gateway_subnet_cidr = optional(string),
    azure_exr_use_2nd_location     = optional(bool, false),
    equinix_metrocode              = string,
    speed_in_mbit                  = string,
    edge_uuid                      = optional(list(string), [null, null]),
    edge_interface                 = optional(number, null),
    metal_service_tokens           = optional(list(string), [null, null]),
    customer_side_asn              = number,
    bgp_auth_key                   = optional(string, "aviatrix1234#!"),
    notifications                  = list(string)
  })
}

locals {
  cloud_type = data.aviatrix_transit_gateway.this.cloud_type

  transit_gw = {
    vpc_id               = data.aviatrix_transit_gateway.this.vpc_id,
    csp_region           = data.aviatrix_transit_gateway.this.vpc_reg,
    transit_subnet_cidrs = compact([data.aviatrix_transit_gateway.this.subnet, data.aviatrix_transit_gateway.this.ha_subnet])
  }

  # Only one module is valid, lets grab the right output.
  module_output = try(coalesce(one(module.directconnect), one(module.expressroute), one(module.cloudinterconnect)), {})
}