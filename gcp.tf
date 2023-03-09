resource "google_compute_router" "this" {
  count = local.is_gcp ? 1 : 0

  name    = "${var.circuit["circuit_name"]}-cloud-router"
  network = split("~-~", var.circuit["vpc_id"])[0]
  bgp {
    asn = 16550
  }
}

resource "google_compute_interconnect_attachment" "primary" {
  count = local.is_gcp ? 1 : 0

  name                     = "${var.circuit["circuit_name"]}-1"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.this[0].id
  mtu                      = 1500
}

resource "google_compute_interconnect_attachment" "secondary" {
  count = var.circuit["cloud_type"] == 8 && (length(compact(var.circuit["edge_uuid"])) == 2 || length(compact(var.circuit["metal_service_tokens"])) == 2) ? true : false ? 1 : 0

  name                     = "${var.circuit["circuit_name"]}-2"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  type                     = "PARTNER"
  router                   = google_compute_router.this[0].id
  mtu                      = 1500
}