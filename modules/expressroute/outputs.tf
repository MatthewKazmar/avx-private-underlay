output "csp_side_peering_addresses" {
  description = "CSP side peering addresses."
  value       = { for i, n in keys(var.circuit["circuit_device_map"]) : n => local.csp_side_peering_addresses[i] }
}

output "customer_side_peering_addresses" {
  description = "Equinix side peering addresses."
  value       = { for i, n in keys(var.circuit["circuit_device_map"]) : n => local.customer_side_peering_addresses[i] }
}