variable "notifications" {
  type = list(string)
  description = "List of notification emails for this Equnix resource."
}

variable "circuit" {
  type = object({
    circuit_name = string,
    aws_vpc_id = optional(string),
    aws_subnet_id = optional(string), 
    azure_vnet_name = optional(string),
    azure_vnet_rg = optional(string),
    azure_vnet_gateway_subnet_cidr = optional(string),
    azure_exr_use_2nd_location = optional(bool, false),
    gcp_vpc_name = optional(string),
    csp_region = string
    equinix_metrocode = string,
    speed_in_mbit = string,
    edge_uuid = list(string),
    edge_interface = list(number)
    edge_asn = number
    vpc_asn = optional(number, 64512)
    bgp_auth_key = optional(string,"aviatrix1234#!")
  })
}

locals {
  is_aws = var.aws_vpc_id != null && var.aws_subnet_id != null && var.azure_vnet_name == null && var.azure_vnet_rg == null && var.vpc_selflink == null ? 1 : 0
  is_azure = var.aws_vpc_id == null && var.aws_subnet_id == null && var.azure_vnet_name != null && var.azure_vnet_rg != null && var.vpc_selflink == null ? 1 : 0
  is_gcp = var.aws_vpc_id == null && var.aws_subnet_id == null && var.azure_vnet_name == null && var.azure_vnet_rg == null && var.vpc_selflink != null ? 1 : 0

  is_aws_redundant = local.is_aws == 1 && length(var.circuit.edge_uuid) == 2  && length(var.circuit.edge_interface) == 2 ? true : false
  is_azure_redundant = local.is_azure == 1 && length(var.circuit.edge_uuid) == 2  && length(var.circuit.edge_interface) == 2 ? true : false
  is_gcp_redundant = local.is_gcp == 1 && length(var.circuit["edge_uuid"]) == 2  && length(var.circuit.edge_interface) == 2 == 2 ? true : false

  cloud = local_is.aws == 1 ? "aws" : local.is_azure == 1 ? "azure": "gcp"

  vpc_asn = {
    aws =  var.circuit["vpc_asn"],
    azure = 12076,
    gcp = 16550
  }  

  l2_connection_count = local.is_aws_redundant || local.is_gcp_redundant ? 2 : 1

  exr_peering_location1 = lookup(local.exr_location_lookup, var.circuit["equinix_metrocode"])
  exr_peering_location2 = coalesce(lookup(local.exr_location_lookup, "${var.circuit["equinix_metrocode"]}2"), local_exr_peeringlocation1)

  exr_peering_location = var.circuit["azure_exr_use_2nd_location"] ? local.exr_peering_location2 : local.exr_peering_location1

  #Microsoft sometimes changes the Metro locations and it isn't reflected in Equinix Seller Profiles. Also, secondary locations.
  exr_location_lookup = {
    "HK" = "Hong Kong SAR",
    "LA" = "Los Angeles2",
    "LA2" = "Los Angeles2"
		"AM" = "Amsterdam",
		"AM" = "Amsterdam2",
		"AT" = "Atlanta",
    #"" = "Berlin",
		"BG" = "Bogota",
		"CA" = "Canberra2",
		"CH" = "Chicago",
		"DA" = "Dallas",
		"DX" = "Dubai2",
		"DB" = "Dublin",
		"FR" = "Frankfurt",
		"FR2" = "Frankfurt2",
		"GV" = "Geneva",
		"HK" = "Hong Kong SAR",
		"HK2" = "Hong Kong2",
		"LD" = "London",
		"LD" = "London2",
		"LA" = "Los Angeles2",
		"LA2" = "Los Angeles2",
		"ME" = "Melbourne",
		"MI" = "Miami",
		"ML" = "Milan",
		"NY" = "New York",
		"OS" = "Osaka",
		"PA" = "Paris",
		"PA2" = "Paris2",
		"PE" = "Perth",
		#"" = "Quebec City",
		"RJ" = "Rio de Janeiro",
		"SP" = "Sao Paulo",
		"SE" = "Seattle",
		"sl" = "Seoul",
		"SV" = "Silicon Valley",
		"SG" = "Singapore",
		"SG2" = "Singapore2",
		"SK" = "Stockholm",
		"SY" = "Sydney",
		"TY" = "Tokyo",
		"TY2" = "Tokyo2",
		"TR" = "Toronto",
		"DC" = "Washington DC",
		"ZH" = "Zurich"
  }
}