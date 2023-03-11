variable "circuit" {
  type = object({
    is_redundant         = bool,
    circuit_name         = string,
    vpc_id               = string,
    route_table_id       = optional(string, ""),
    csp_region           = string
    equinix_metrocode    = string,
    speed_in_mbit        = string,
    edge_uuid            = optional(list(string), [null, null]),
    edge_interface       = optional(list(number), [null, null]),
    metal_service_tokens = optional(list(string), [null, null]),
    customer_side_asn    = number,
    vpc_asn              = optional(number, 64512),
    bgp_auth_key         = optional(string, "aviatrix1234#!"),
    notifications        = list(string)
  })
}