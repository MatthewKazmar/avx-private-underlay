output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = { for k, v in google_compute_interconnect_attachment.this : k => v.cloud_router_ip_address }
}

output "customer_side_peering_addresses" {
  description = "Customer (Equinix Metal/Edge/Colo) side peering addresses."
  value       = { for k, v in google_compute_interconnect_attachment.this : k => v.customer_router_ip_address }
}