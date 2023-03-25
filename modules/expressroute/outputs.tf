output "csp_side_peering_addresses" {
  description = "CSP side peering addresses."
  value = {
    (var.circuit["circuit_name"][0]) = "${cidrhost(azurerm_express_route_circuit_peering.this.primary_peer_address_prefix, 2)}/30",
    (var.circuit["circuit_name"][1]) = "${cidrhost(azurerm_express_route_circuit_peering.this.secondary_peer_address_prefix, 2)}/30"
  }
}

output "customer_side_peering_addresses" {
  description = "Equinix side peering addresses."
  value = {
    (var.circuit["circuit_name"][0]) = "${cidrhost(azurerm_express_route_circuit_peering.this.primary_peer_address_prefix, 1)}/30",
    (var.circuit["circuit_name"][1]) = "${cidrhost(azurerm_express_route_circuit_peering.this.secondary_peer_address_prefix, 1)}/30"
  }
}