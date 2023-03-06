resource "azurerm_express_route_circuit" "this" {
  count = local.is_azure

  resource_group_name   = var.circuit["azure_vnet_rg"]
  name                  = var.circuit["circuit_name"]
  location              = var.circuit["csp_region"]
  service_provider_name = "Equinix"
  peering_location      = lookup(local.exr_location_lookup, var.circuit["equinix_metrocode"])
  bandwidth_in_mbps     = var.circuit["speed_in_mbit"]

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  allow_classic_operations = false
}

resource "random_integer" "exr_subnet" {
  min = 0
  max = 8191
}

locals {
  exr_address = cidrsubnet("169.254.0.0/16", 14, random_integer.exr_subnet.result)
  exr_primary_address = cidrsubnet(local.exr_address, 1, 0)
  exr_secondary_address = cidrsubnet(local.exr_address, 1, 1)
}

resource "azurerm_express_route_circuit_peering" "this" {
  count = local.is_azure

  resource_group_name           = var.circuit["azure_vnet_rg"]
  express_route_circuit_name    = azurerm_express_route_circuit.this.name
  peering_type                  = "AzurePrivatePeering"
  peer_asn                      = var.circuit["edge_asn"]
  primary_peer_address_prefix   = local.exr_primary_address
  secondary_peer_address_prefix = local.exr_secondary_address
  vlan_id                       = random_integer.vlan[0].result
  shared_key                    = var.circuit["bgp_auth_key"]
}

resource "azurerm_public_ip" "this" {
  count = local.is_azure

  resource_group_name = var.circuit["azure_vnet_rg"]
  location            = var.circuit["csp_region"]
  name                = "${var.circuit["circuit_name"]}-pip"
  sku                 = "Basic"
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet" "this" {
  count = local.is_azure

  name = "GatewaySubnet"
  resource_group_name = var.circuit["azure_vnet_rg"]
  virtual_network_name = var.circuit["azure_vnet_name"]

  address_prefixes = [var.circuit["azure_vnet_gateway_subnet_cidr"]]

}

resource "azurerm_virtual_network_gateway" "this" {
  count = local.is_azure

  resource_group_name = var.circuit["azure_vnet_rg"]
  location            = var.circuit["csp_region"]
  name                = "${var.circuit["circuit_name"]}-gateway"
  type                = "ExpressRoute"

  sku           = "Standard"
  active_active = false
  enable_bgp    = false

  ip_configuration {
    name                          = "default"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.this[0].id
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  count = local.is_azure

  name                       = "${var.circuit["circuit_name"]}-gateway-connection"
  resource_group_name        = azurerm_virtual_network_gateway.this[0].resource_group_name
  location                   = azurerm_virtual_network_gateway.this[0].location
  type                       = "ExpressRoute"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this[0].id
  express_route_circuit_id   = azurerm_express_route_circuit.this[0].id
}