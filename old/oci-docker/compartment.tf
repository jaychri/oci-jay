
resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for docker resources. Terraformed"
  name           = "tf-oci-docker"
}

