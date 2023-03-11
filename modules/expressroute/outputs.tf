output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = [cidrhost(azurerm_express_route_circuit_peering.this.primary_peer_address_prefix, 2), cidrhost(azurerm_express_route_circuit_peering.this.secondary_peer_address_prefix, 2)]
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value       = [cidrhost(azurerm_express_route_circuit_peering.this.primary_peer_address_prefix, 1), cidrhost(azurerm_express_route_circuit_peering.this.secondary_peer_address_prefix, 1)]
}