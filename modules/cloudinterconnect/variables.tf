variable "circuit" {
  type = object({
    base_circuit_name = string,
    # circuit_name         = list(string),
    vpc_id             = string,
    csp_region         = string
    equinix_metrocode  = string,
    speed              = string,
    circuit_device_map = map(string),
    device_type        = string,
    customer_side_asn  = number,
    bgp_auth_key       = optional(string, "aviatrix1234#!"),
    notifications      = list(string)
  })
}

locals {
  network = split("~-~", var.circuit["vpc_id"])[0]
  project = split("~-~", var.circuit["vpc_id"])[1]

  #Aviatrix GCP Gateway lists the zone in the vpc_reg attribute.
  csp_region = regex("[a-z]+-[a-z0-9]+", var.circuit["csp_region"])

}