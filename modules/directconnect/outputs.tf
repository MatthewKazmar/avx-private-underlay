output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = aws_dx_private_virtual_interface.this[*].amazon_address
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value       = aws_dx_private_virtual_interface.this[*].customer_address
}