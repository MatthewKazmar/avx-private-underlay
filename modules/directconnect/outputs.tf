output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = { for k, v in aws_dx_private_virtual_interface.this : k => v.amazon_address }
}

output "customer_side_peering_addresses" {
  description = "Equinix side peering addresses."
  value       = { for k, v in aws_dx_private_virtual_interface.this : k => v.customer_address }
}