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
  }

  authorization_key = coalescelist(data.aws_caller_identity.this[*].account_id, azurerm_express_route_circuit.this[*].service_key, google_compute_interconnect_attachment.this[*].pairing_key)

  sellerprofile = local.sellerprofile_map[local.cloud]
}

data "equinix_ecx_l2_sellerprofile" "profiles" {
  for_each = toset(local.sellerprofiles)
  name     = each.key
}

resource "equinix_ecx_l2_connection" "this" {
  count = local.is_azure == 1 ? 1 : local.is_redundant ? 2 : 1

  name                = "${var.circuit["circuit_name"]}-${count.index + 1}"
  profile_uuid        = data.equinix_ecx_l2_sellerprofile.profiles[local.sellerprofile_map[local.cloud][count.index]]
  speed               = var.circuit["speed_in_mbit"]
  speed_unit          = "MB"
  notifications       = var.circuit["notifications"]
  device_uuid         = var.circuit["edge_uuid"][count.index]
  device_interface_id = var.circuit["edge_interface"][count.index]
  service_token       = var.circuit["metal_service_tokens"][count.index]
  seller_region       = var.circuit["csp_region"]
  seller_metro_code   = var.circuit["equinix_metrocode"]
  authorization_key   = local.is_gcp == 1 ? local.authorization_key[count.index] : local.authorization_key[0]
  named_tag           = local.is_azure == 1 ? "PRIVATE" : null

  dynamic "secondary_connection" {
    for_each = local.is_azure_redundant ? [1] : []
    content {
      name                = "${var.circuit["circuit_name"]}-2"
      device_uuid         = var.circuit["edge_uuid"][1]
      device_interface_id = var.circuit["edge_interface"][1]
      service_token       = var.circuit["metal_service_tokens"][1]
    }
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }

  lifecycle {
    ignore_changes = all
  }
}