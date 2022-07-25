resource "oci_core_vcn" "vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "vcn-${var.hostname}"
  dns_label      = "vcn${var.hostname}"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "ig-${var.hostname}"
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  display_name               = "rt-${var.hostname}"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_subnet" "subnet" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  cidr_block          = "10.1.0.0/24"
  display_name        = "subnet-${var.hostname}"
  dns_label           = "subnet${var.hostname}"
  # security_list_ids   = [oci_core_security_list.empty_security_list.id]
  compartment_id  = oci_identity_compartment.compartment.id
  vcn_id          = oci_core_vcn.vcn.id
  route_table_id  = oci_core_vcn.vcn.default_route_table_id
  dhcp_options_id = oci_core_vcn.vcn.default_dhcp_options_id
}

