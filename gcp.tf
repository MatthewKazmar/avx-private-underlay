resource "google_compute_router" "this" {
  count = local.is_gcp

  name    = "${var.circuit["circuit_name"]}-cloud-router"
  network = var.circuit["gcp_vpc_name"]
  bgp {
    asn = 16550
  }
}

resource "google_compute_interconnect_attachment" "this" {
  count = local.is_gcp * local.l2_connection_count

  name                     = "${var.circuit["circuit_name"]}-${count+1}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_${count+1}"
  type                     = "PARTNER"
  router                   = google_compute_router.this[0].id
  mtu                      = 1500
}