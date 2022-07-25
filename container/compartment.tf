
resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  description    = "Resources created by docker from DevStation1"
  name           = "DevStation1"
}

