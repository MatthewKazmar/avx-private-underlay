variable "circuit" {
  type = object({
    base_circuit_name = string,
    # circuit_name         = list(string),
    vpc_id             = string,
    rtb                = string,
    csp_region         = string,
    equinix_metrocode  = string,
    speed              = string,
    circuit_device_map = map(string),
    edge_interface     = optional(number),
    device_type        = string,
    customer_side_asn  = number,
    vpc_asn            = optional(number, 64512),
    bgp_auth_key       = optional(string, "aviatrix1234#!"),
    notifications      = list(string)
  })
}