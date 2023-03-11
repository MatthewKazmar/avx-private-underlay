output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value = coalescelist(
    module.directconnect.csp_peering_addresses,
    module.expressroute.csp_peering_addresses,
    module.cloudinterconnect.csp_peering_addresses
  )
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value = coalescelist(
    module.directconnect.equinix_peering_addresses,
    module.expressroute.equinix_peering_addresses,
    module.cloudinterconnect.equinix_peering_addresses
  )
}