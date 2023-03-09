output "peering_cidrs" {
  description = "CIDR blocks for peering."
  value       = local.peering_cidrs
}

# output "csp_peering_addresses" {
#   description = "CSP side peering addresses."
#   value = coalescelist(
#     [google_compute_interconnect_attachment.primary[*].cloud_router_ip_address, google_compute_interconnect_attachment.secondary[*].cloud_router_ip_address],
#   [cidrhost(local.peering_cidrs[0], 2), cidrhost(local.peering_cidrs[1], 2)])
# }

# output "equinix_peering_addresses" {
#   description = "Equinix side peering addresses."
#   value = coalescelist(
#     [google_compute_interconnect_attachment.primary[*].customer_router_ip_address, google_compute_interconnect_attachment.secondary[*].customer_router_ip_address],
#   [cidrhost(local.peering_cidrs[0], 1), cidrhost(local.peering_cidrs[1], 1)])
# }

output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = [cidrhost(local.peering_cidrs[0], 2), cidrhost(local.peering_cidrs[1], 2)]
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value       = [cidrhost(local.peering_cidrs[0], 1), cidrhost(local.peering_cidrs[1], 1)]
}
