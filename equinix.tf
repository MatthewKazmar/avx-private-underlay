locals {
  sellerprofiles = [
    "AWS Direct Connect",
    "Azure ExpressRoute",
    "Google Cloud Partner Interconnect Zone 1",
    "Google Cloud Partner Interconnect Zone 2"
  ]

  sellerprofile_map = {
    aws   = ["AWS Direct Connect", "AWS Direct Connect"],
    azure = ["Azure ExpressRoute"],
    gcp   = ["Google Cloud Partner Interconnect Zone 1", "Google Cloud Partner Interconnect Zone 2"]

    authorization_key = coalescelist(data.aws_caller_identity.*.account_id, azurerm_express_route_circuit.this.*.service_key, google_compute_interconnect_attachment.this.*.pairing_key)
  }

  sellerprofile = sellerprofile_map[local.cloud]
}

data "equinix_ecx_l2_sellerprofile" "profiles" {
  for_each = toset(local.sellerprofiles)
}

resource "equinix_ecx_l2_connection" "this" {
  count = local.l2_connection_count

  name                   = "${var.circuit["circuit_name"]}-${count + 1}"
  profile_uuid           = data.equinix_ecx_l2_sellerprofile.profiles[local.cloud]
  speed                  = var.circuit["speed_in_mbit"]
  speed_unit             = "MB"
  notifications          = var.notifications
  device_uuid            = var.circuit["edge_uuid"][count] == "" ? null : var.circuit["edge_uuid"][count]
  device_interface_id    = var.circuit["edge_interface"][count] == "" ? null : var.circuit["edge_interface"][count]
  zside_service_token_id = var.circuit["metal_service_tokens"][count] == "" ? null : var.circuit["metal_service_tokens"][count]
  seller_region          = var.circuit["csp_region"]
  seller_metro_code      = var.circuit["equinix_metrocode"]
  authorization_key      = local.is_gcp == 1 ? local.authorization_key[count] : local.authorization_key[0]

  dynamic "secondary_connection" {
    for_each = local.is_azure_redundant ? [1] : []

    name                   = "${var.circuit["circuit_name"]}-2"
    device_uuid            = var.circuit["edge_uuid"][1] == "" ? null : var.circuit["edge_uuid"][1]
    device_interface_id    = var.circuit["edge_interface"][1] == "" ? null : var.circuit["edge_interface"][1]
    zside_service_token_id = var.circuit["metal_service_tokens"][1] == "" ? null : var.circuit["metal_service_tokens"][1]
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }

  lifecycle {
    ignore_changes = all
  }
}