output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value = coalescelist(
    one(module.directconnect).csp_peering_addresses,
    one(module.expressroute).csp_peering_addresses,
    one(module.cloudinterconnect).csp_peering_addresses
  )
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value = coalescelist(
    one(module.directconnect).equinix_peering_addresses,
    one(module.expressroute).equinix_peering_addresses,
    one(module.cloudinterconnect).equinix_peering_addresses
  )
}