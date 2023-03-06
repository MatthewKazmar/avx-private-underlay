output "peering_cidrs" {
  description = "CIDR blocks for peering."
  value = local.peering_cidrs
}

output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value = coalescelist(google_compute_interconnect_attachment.this.*.cloud_router_ip_address, [cidrhost(local.peering_cidrs[0], 2), cidrhost(local.peering_cidrs[1], 2)])
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value = coalescelist(google_compute_interconnect_attachment.this.*.customer_router_ip_address, [cidrhost(local.peering_cidrs[0], 2), cidrhost(local.peering_cidrs[1], 2)])
}
