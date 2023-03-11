# Kicks off module based on cloud type.

module "directconnect" {
  count = var.circuit["cloud_type"] == 1 ? 1 : 0

  source = "./modules/directconnect"

  circuit = local.circuit
}

module "expressroute" {
  count = var.circuit["cloud_type"] == 8 ? 1 : 0

  source = "./modules/expressroute"

  circuit = local.circuit
}

module "cloudinterconnect" {
  count = var.circuit["cloud_type"] == 4 ? 1 : 0

  source = "./modules/cloudinterconnect"

  circuit = local.circuit
}