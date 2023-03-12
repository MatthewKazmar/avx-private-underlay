output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = try(local.module_output.csp_peering_addresses, [])
}

output "customer_side_peering_addresses" {
  description = "Customer (Equinix Metal/Edge/Colo) peering addresses."
  value       = try(local.module_output.customer_side_peering_addresses, [])
}

output "customer_side_vlan_tags" {
  description = "Customer (Equinix Metal/Edge/Colo) vlans."
  value       = try(local.module_output.customer_side_vlan_tags, [])
}