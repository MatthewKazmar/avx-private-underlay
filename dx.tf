data "aws_caller_identity" "this" {
  count = local.is_aws ? 1 : 0
}

resource "aws_dx_connection_confirmation" "primary" {
  count = local.is_aws ? 1 : 0

  connection_id = one([for action_data in one(equinix_ecx_l2_connection.primary.actions).required_data : action_data["value"] if action_data["key"] == "awsConnectionId"])
}

resource "aws_dx_connection_confirmation" "secondary" {
  count = local.is_aws_redundant ? 1 : 0

  connection_id = one([for action_data in one(equinix_ecx_l2_connection.secondary[0].actions).required_data : action_data["value"] if action_data["key"] == "awsConnectionId"])
}

resource "aws_vpn_gateway" "this" {
  count = local.is_aws ? 1 : 0

  amazon_side_asn = local.vpc_asn["aws"]
  tags = {
    Name = "${var.circuit["circuit_name"]}-gateway"
  }
}

resource "aws_vpn_gateway_attachment" "this" {
  count = local.is_aws ? 1 : 0

  vpc_id         = var.circuit["vpc_id"]
  vpn_gateway_id = aws_vpn_gateway.this[0].id
}

resource "aws_dx_private_virtual_interface" "primary" {
  count = local.is_aws ? 1 : 0

  connection_id    = aws_dx_connection_confirmation.primary[0].id
  name             = "${equinix_ecx_l2_connection.primary.name}-pvif"
  vlan             = random_integer.vlan[0].result
  address_family   = "ipv4"
  bgp_asn          = var.circuit["equinix_side_asn"]
  bgp_auth_key     = var.circuit["bgp_auth_key"]
  vpn_gateway_id   = aws_vpn_gateway.this[0].id
  amazon_address   = "${cidrhost(local.peering_cidrs[0], 2)}/30"
  customer_address = "${cidrhost(local.peering_cidrs[0], 1)}/30"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "aws_dx_private_virtual_interface" "secondary" {
  count = local.is_aws_redundant ? 1 : 0

  connection_id    = aws_dx_connection_confirmation.secondary[0].id
  name             = "${equinix_ecx_l2_connection.secondary[0].name}-pvif"
  vlan             = random_integer.vlan[0].result
  address_family   = "ipv4"
  bgp_asn          = var.circuit["equinix_side_asn"]
  bgp_auth_key     = var.circuit["bgp_auth_key"]
  vpn_gateway_id   = aws_vpn_gateway.this[0].id
  amazon_address   = "${cidrhost(local.peering_cidrs[1], 2)}/30"
  customer_address = "${cidrhost(local.peering_cidrs[1], 1)}/30"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

data "aws_route_table" "this" {
  count = local.is_aws ? 1 : 0

  subnet_id = var.circuit["subnet_id"]
}

resource "aws_vpn_gateway_route_propagation" "this" {
  count = local.is_aws ? 1 : 0

  vpn_gateway_id = aws_vpn_gateway.this[0].id
  route_table_id = data.aws_route_table.this[0].id
}
