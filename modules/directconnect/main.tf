data "aws_caller_identity" "this" {}

data "aws_subnets" "this" {
  filter {
    name   = "cidr-block"
    values = var.circuit["transit_subnet_cidrs"]
  }
}

data "aws_route_tables" "this" {
  filter {
    name   = "association.subnet-id"
    values = data.aws_subnets.this.ids
  }
}

data "equinix_ecx_l2_sellerprofile" "this" {
  name = "AWS Direct Connect"
}

resource "equinix_ecx_l2_connection" "this" {
  for_each = var.circuit["circuit_device_map"]

  name                = each.key
  profile_uuid        = data.equinix_ecx_l2_sellerprofile.this.id
  speed               = var.circuit["speed"]
  speed_unit          = "MB"
  notifications       = var.circuit["notifications"]
  device_uuid         = var.circuit["device_type"] == "network-edge" ? each.value : null
  device_interface_id = var.circuit["device_type"] == "network-edge" ? var.circuit["edge_interface"] : null
  service_token       = var.circuit["device_type"] == "metal" ? each.value : null
  seller_region       = var.circuit["csp_region"]
  seller_metro_code   = var.circuit["equinix_metrocode"]
  authorization_key   = data.aws_caller_identity.this.account_id

  timeouts {
    create = "20m"
    delete = "20m"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_dx_connection_confirmation" "this" {
  for_each = equinix_ecx_l2_connection.this

  connection_id = one([for action_data in one(each.value.actions).required_data : action_data["value"] if action_data["key"] == "awsConnectionId"])
}

resource "aws_vpn_gateway" "this" {
  amazon_side_asn = var.circuit["vpc_asn"]
  tags = {
    Name = "${var.circuit["base_circuit_name"]}-gateway"
  }
}

resource "aws_vpn_gateway_route_propagation" "this" {
  for_each = toset(data.aws_route_tables.this.ids)

  vpn_gateway_id = aws_vpn_gateway.this.id
  route_table_id = each.value
}

resource "aws_vpn_gateway_attachment" "this" {
  vpc_id         = var.circuit["vpc_id"]
  vpn_gateway_id = aws_vpn_gateway.this.id
}

resource "aws_dx_private_virtual_interface" "this" {
  for_each = aws_dx_connection_confirmation.this

  connection_id  = each.value.id
  name           = "${equinix_ecx_l2_connection.this[each.key].name}-pvif"
  vlan           = equinix_ecx_l2_connection.this[each.key].zside_vlan_stag
  address_family = "ipv4"
  bgp_asn        = var.circuit["customer_side_asn"]
  bgp_auth_key   = var.circuit["bgp_auth_key"]
  vpn_gateway_id = aws_vpn_gateway.this.id

  timeouts {
    create = "20m"
    delete = "20m"
  }

  lifecycle {
    ignore_changes = all
  }
}