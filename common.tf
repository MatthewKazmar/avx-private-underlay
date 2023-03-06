resource "random_integer" "vlan" {
  count = 2

  min = 100
  max = 1000
}

resource "random_integer" "peering_cidr" {
  min = 0
  max = 8191
}

locals {
  peering_cidr  = cidrsubnet("169.254.0.0/16", 14, random_integer.peering_cidr.result)
  peering_cidrs = [cidrsubnet(local.peering_cidr, 1, 0), cidrsubnet(local.peering_cidr, 1, 1)]
}