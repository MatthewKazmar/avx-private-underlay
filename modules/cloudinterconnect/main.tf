data "equinix_ecx_l2_sellerprofile" "this" {
  count = 2
  name  = "Google Cloud Partner Interconnect Zone ${count.index + 1}"
}

resource "google_compute_router" "this" {
  project = local.project
  name    = "${var.circuit["base_circuit_name"]}-cloud-router"
  region  = local.csp_region
  network = local.network
  bgp {
    asn = 16550
  }
}

resource "google_compute_interconnect_attachment" "this" {
  for_each = var.circuit["circuit_device_map"]

  project                  = local.project
  name                     = each.key
  region                   = google_compute_router.this.region
  edge_availability_domain = "AVAILABILITY_DOMAIN_${index(var.circuit["circuit_name"], each.key) + 1}"
  type                     = "PARTNER"
  router                   = google_compute_router.this.id
  mtu                      = 1500
}

# In google_compute_router_peer, the interface attribute is mandatory.
# The interface name is auto-ia-<attachment name>-<random string>.
# There is no Terraform method for retrieving this interface name.

# resource "google_compute_router_peer" "this" {
#   count = var.circuit["is_redundant"] ? 2 : 1

#   project         = local.project
#   name            = "${google_compute_interconnect_attachment.this[count.index].name}-peer"
#   region          = google_compute_router.this.region
#   peer_ip_address = regex("[0-9.]+", google_compute_interconnect_attachment.this[count.index].customer_router_ip_address)
#   peer_asn        = var.circuit["customer_side_asn"]
#   interface       = "interface-${count.index}"
#   router          = google_compute_router.this.name
# }

resource "equinix_ecx_l2_connection" "this" {
  for_each = google_compute_interconnect_attachment.this

  name                = each.key
  profile_uuid        = data.equinix_ecx_l2_sellerprofile.this[each.key].id
  speed               = var.circuit["speed"]
  speed_unit          = "MB"
  notifications       = var.circuit["notifications"]
  device_uuid         = var.circuit["device_type"] == "network-edge" ? each.value : null
  device_interface_id = var.circuit["device_type"] == "network-edge" ? var.circuit["edge_interface"] : null
  service_token       = var.circuit["device_type"] == "metal" ? each.value : null
  seller_region       = local.csp_region
  seller_metro_code   = var.circuit["equinix_metrocode"]
  authorization_key   = each.value.pairing_key

  timeouts {
    create = "20m"
    delete = "20m"
  }

  lifecycle {
    ignore_changes = all
  }
}