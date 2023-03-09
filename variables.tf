variable "circuit" {
  type = object({
    circuit_name                   = string,
    cloud_type                     = number,
    vpc_id                         = string,
    vpc_cidr                       = optional(string, ""),
    subnet_id                      = optional(string, ""),
    azure_vnet_gateway_subnet_cidr = optional(string),
    azure_exr_use_2nd_location     = optional(bool, false),
    csp_region                     = string
    equinix_metrocode              = string,
    speed_in_mbit                  = string,
    edge_uuid                      = optional(list(string), [null, null]),
    edge_interface                 = optional(list(number), [null, null]),
    metal_service_tokens           = optional(list(string), [null, null]),
    equinix_side_asn               = number,
    vpc_asn                        = optional(number, 64512),
    bgp_auth_key                   = optional(string, "aviatrix1234#!"),
    notifications                  = list(string)
  })
}

locals {
  is_redundant = length(compact(var.circuit["edge_uuid"])) == 2 || length(compact(var.circuit["metal_service_tokens"])) == 2 ? true : false

  cloud_map = {
    "1" = "aws",
    "8" = "azure",
    "4" = "gcp"
  }

  cloud = local.cloud_map[var.circuit["cloud_type"]]

  is_aws   = local.cloud == "aws" ? true : false
  is_azure = local.cloud == "azure" ? true : false
  is_gcp   = local.cloud == "gcp" ? true : false

  is_aws_redundant   = local.cloud == "aws" && local.is_redundant ? true : false
  is_azure_redundant = local.cloud == "azure" && local.is_redundant ? true : false
  is_gcp_redundant   = var.circuit["cloud_type"] == 8 && length(compact(var.circuit["edge_uuid"])) == 2 || length(compact(var.circuit["metal_service_tokens"])) == 2 ? true : false

  csp_region = local.is_gcp == 1 ? substr(var.circuit["csp_region"], 0, length(var.circuit["csp_region"]) - 2) : var.circuit["csp_region"]

  vpc_asn = {
    aws   = var.circuit["vpc_asn"],
    azure = 12076,
    gcp   = 16550
  }

  azure_vnet_gateway_subnet_cidr = coalesce(var.circuit["azure_vnet_gateway_subnet_cidr"], cidrsubnet(var.circuit["vpc_cidr"], 6, 15), "none") #Grab last /27 in a /23

  exr_peering_location1 = lookup(local.exr_location_lookup, var.circuit["equinix_metrocode"])
  exr_peering_location2 = coalesce(lookup(local.exr_location_lookup, "${var.circuit["equinix_metrocode"]}2", null), local.exr_peering_location1)

  exr_peering_location = var.circuit["azure_exr_use_2nd_location"] ? local.exr_peering_location2 : local.exr_peering_location1

  #Microsoft sometimes changes the Metro locations and it isn't reflected in Equinix Seller Profiles. Also, secondary locations.
  exr_location_lookup = {
    "HK"  = "Hong Kong SAR",
    "LA"  = "Los Angeles2",
    "LA2" = "Los Angeles2"
    "AM"  = "Amsterdam",
    "AM"  = "Amsterdam2",
    "AT"  = "Atlanta",
    #"" = "Berlin",
    "BG"  = "Bogota",
    "CA"  = "Canberra2",
    "CH"  = "Chicago",
    "DA"  = "Dallas",
    "DX"  = "Dubai2",
    "DB"  = "Dublin",
    "FR"  = "Frankfurt",
    "FR2" = "Frankfurt2",
    "GV"  = "Geneva",
    "HK"  = "Hong Kong SAR",
    "HK2" = "Hong Kong2",
    "LD"  = "London",
    "LD"  = "London2",
    "LA"  = "Los Angeles2",
    "LA2" = "Los Angeles2",
    "ME"  = "Melbourne",
    "MI"  = "Miami",
    "ML"  = "Milan",
    "NY"  = "New York",
    "OS"  = "Osaka",
    "PA"  = "Paris",
    "PA2" = "Paris2",
    "PE"  = "Perth",
    #"" = "Quebec City",
    "RJ"  = "Rio de Janeiro",
    "SP"  = "Sao Paulo",
    "SE"  = "Seattle",
    "sl"  = "Seoul",
    "SV"  = "Silicon Valley",
    "SG"  = "Singapore",
    "SG2" = "Singapore2",
    "SK"  = "Stockholm",
    "SY"  = "Sydney",
    "TY"  = "Tokyo",
    "TY2" = "Tokyo2",
    "TR"  = "Toronto",
    "DC"  = "Washington DC",
    "ZH"  = "Zurich"
  }
}