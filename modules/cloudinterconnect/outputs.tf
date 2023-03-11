output "csp_peering_addresses" {
  description = "CSP side peering addresses."
  value       = google_compute_interconnect_attachment.this[*].cloud_router_ip_address
}

output "equinix_peering_addresses" {
  description = "Equinix side peering addresses."
  value       = google_compute_interconnect_attachment.this[*].customer_router_ip_address
}