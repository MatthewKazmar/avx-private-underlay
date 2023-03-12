# Kicks off module based on cloud type.
data "aviatrix_transit_gateway" "this" {
  gw_name = var.circuit["transit_gw"]
}

module "directconnect" {
  count = var.circuit["cloud_type"] == 1 ? 1 : 0

  source = "./modules/directconnect"

  circuit = merge(var.circuit, local.transit_gw)

}

module "expressroute" {
  count = var.circuit["cloud_type"] == 8 ? 1 : 0

  source = "./modules/expressroute"

  circuit = merge(var.circuit, local.transit_gw)
}

module "cloudinterconnect" {
  count = var.circuit["cloud_type"] == 4 ? 1 : 0

  source = "./modules/cloudinterconnect"

  circuit = merge(var.circuit, local.transit_gw)
}