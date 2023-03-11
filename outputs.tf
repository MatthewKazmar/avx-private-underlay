output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = local.module_output.csp_peering_addresses
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value       = local.module.equinix_peering_addresses
}