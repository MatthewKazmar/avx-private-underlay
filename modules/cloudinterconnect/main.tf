data "equinix_ecx_l2_sellerprofile" "this" {
  count = 2
  name  = "Google Cloud Partner Interconnect Zone ${count.index + 1}"
}

resource "google_compute_router" "this" {
  name    = "${var.circuit["circuit_name"]}-cloud-router"
  region  = local.csp_region
  network = local.network
  bgp {
    asn = 16550
  }
}

resource "google_compute_interconnect_attachment" "this" {
  count = var.circuit["is_redundant"] ? 2 : 1

  name                     = "${var.circuit["circuit_name"]}-${count.index + 1}"
  region                   = google_compute_router.this.region
  edge_availability_domain = "AVAILABILITY_DOMAIN_${count.index + 1}"
  type                     = "PARTNER"
  router                   = google_compute_router.this.id
  mtu                      = 1500
}

resource "equinix_ecx_l2_connection" "this" {
  count = var.circuit["is_redundant"] ? 2 : 1

  name                = "${var.circuit["circuit_name"]}-${count.index + 1}"
  profile_uuid        = data.equinix_ecx_l2_sellerprofile.this[count.index].id
  speed               = var.circuit["speed_in_mbit"]
  speed_unit          = "MB"
  notifications       = var.circuit["notifications"]
  device_uuid         = var.circuit["edge_uuid"][count.index]
  device_interface_id = var.circuit["edge_interface"][count.index]
  service_token       = var.circuit["metal_service_tokens"][count.index]
  seller_region       = var.circuit["csp_region"]
  seller_metro_code   = var.circuit["equinix_metrocode"]
  authorization_key   = google_compute_interconnect_attachment.this[count.index].pairing_key

  timeouts {
    create = "20m"
    delete = "20m"
  }

  lifecycle {
    ignore_changes = all
  }
}