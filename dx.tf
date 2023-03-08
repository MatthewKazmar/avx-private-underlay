data "aws_caller_identity" "aws" {
  count = local.is_aws
}

resource "aws_dx_connection_confirmation" "this" {
  count = local.is_aws * local.l2_connection_count

  connection_id = one([for action_data in one(equinix_ecx_l2_connection.this[count].actions).required_data : action_data["value"] if action_data["key"] == "awsConnectionId"])
}

resource "aws_vpn_gateway" "this" {
  count = local.is_aws

  amazon_side_asn = local.vpc_asn["aws"]
  tags = {
    Name = "${var.circuit["circuit_name"]}-gateway"
  }
}

resource "aws_vpn_gateway_attachment" "this" {
  count = local.is_aws

  vpc_id         = var.circuit["vpc_id"]
  vpn_gateway_id = aws_vpn_gateway.this[0].id
}

resource "aws_dx_private_virtual_interface" "this" {
  count = local.is_aws * local.l2_connection_count

  connection_id    = aws_dx_connection_confirmation.this[count].id
  name             = "${var.circuit["circuit_name"]}-pvif"
  vlan             = random_integer.vlan[count].result
  address_family   = "ipv4"
  bgp_asn          = var.circuit["equinix_side_asn"]
  bgp_auth_key     = var.bgp_auth_key
  vpn_gateway_id   = aws_vpn_gateway.this[0].id
  amazon_address   = "${cidrhost(local.peering_cidrs[count], 2)}/30"
  customer_address = "${cidrhost(local.peering_cidrs[count], 1)}/30"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

data "aws_route_table" "this" {
  count = local.is_aws

  subnet_id = var.circuit["subnet_id"]
}

resource "aws_vpn_gateway_route_propagation" "this" {
  count = local.is_aws

  vpn_gateway_id = aws_vpn_gateway.this[0].id
  route_table_id = data.aws_route_table.this[0].id
}
