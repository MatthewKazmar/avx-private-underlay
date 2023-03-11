variable "circuit" {
  type = object({
    is_redundant                   = bool,
    circuit_name                   = string,
    cloud_type                     = number,
    vpc_id                         = string,
    route_table_id                 = optional(string, ""),
    azure_vnet_gateway_subnet_cidr = optional(string),
    azure_exr_use_2nd_location     = optional(bool, false),
    csp_region                     = string
    equinix_metrocode              = string,
    speed_in_mbit                  = string,
    edge_uuid                      = optional(list(string), [null, null]),
    edge_interface                 = optional(list(number), [null, null]),
    metal_service_tokens           = optional(list(string), [null, null]),
    customer_side_asn              = number,
    bgp_auth_key                   = optional(string, "aviatrix1234#!"),
    notifications                  = list(string)
  })
}