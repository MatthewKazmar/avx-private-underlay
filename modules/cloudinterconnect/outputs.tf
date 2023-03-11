output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = google_compute_interconnect_attachment.this[*].cloud_router_ip_address
}

output "customer_side_peering_addresses" {
  description = "Customer (Equinix Metal/Edge/Colo) side peering addresses."
  value       = google_compute_interconnect_attachment.this[*].customer_router_ip_address
}

output "customer_side_vlan_tags" {
  description = "Customer (Equinix Metal/Edge/Colo) vlans."
  value       = local.module_output.customer_side_vlan_tags
}