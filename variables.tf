variable "circuit" {
  type = object({
    cloud_type        = number,
    base_circuit_name = string,
    # circuit_name         = list(string),
    vpc_id             = string,
    csp_region         = string,
    equinix_metrocode  = string,
    speed              = string,
    circuit_device_map = map(string),
    edge_interface     = optional(number),
    device_type        = string,
    customer_side_asn  = number,
    vpc_asn            = optional(number, 64512),
    bgp_auth_key       = optional(string, "aviatrix1234#!"),
    notifications      = list(string),
    #AWS
    rtb = optional(string),
    #Azure
    azure_vnet_gateway_subnet_cidr = optional(string, null),
    azure_exr_use_2nd_location     = optional(bool, false),
  })
}

locals {
  # Only one module is valid, lets grab the right output.
  module_output = try(coalesce(one(module.directconnect), one(module.expressroute), one(module.cloudinterconnect)), {})

  csp_asn = {
    1 = var.circuit["vpc_asn"],
    4 = 16550,
    8 = 12076
  }
}