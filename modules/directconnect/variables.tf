variable "circuit" {
  type = object({
    is_redundant         = bool,
    base_circuit_name = string,
    circuit_name         = list(string),
    vpc_id               = string,
    transit_subnet_cidrs = list(string),
    csp_region           = string,
    equinix_metrocode    = string,
    speed                = string,
    edge_uuid            = optional(list(string), [null, null]),
    edge_interface       = optional(number, null),
    metal_service_tokens = optional(list(string), [null, null]),
    customer_side_asn    = number,
    vpc_asn              = optional(number, 64512),
    bgp_auth_key         = optional(string, "aviatrix1234#!"),
    notifications        = list(string)
  })
}