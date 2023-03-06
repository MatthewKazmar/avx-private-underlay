# avx-private-underlay
This module reates a private circuit for AWS, Azure, GCP to Equinix Fabric for Aviatrix Edge in Equinix.

This module must be deployed after:
* Transit VPC creation: We need a VPC to create the endpoint.
* Aviatrix Edge deployment: The Equinix circuit needs somewhere to land.

Valid CSP and Equinix Credentials are required.

AWS: Connects to a VGW.
Azure: Connects to Virtual Network Gateway.
GCP: Creates a VLAN attachment.