# See https://docs.oracle.com/iaas/images/
# data "oci_core_images" "base_images_oracle" {
#   compartment_id           = var.compartment_ocid
#   operating_system         = "Oracle Linux"
#   operating_system_version = "8"
#   shape                    = var.instance_shape
#   sort_by                  = "TIMECREATED"
#   sort_order               = "DESC"
# }

# data "oci_core_images" "base_images_ubuntu" {
#   compartment_id           = var.compartment_ocid
#   operating_system         = "Canonical Ubuntu"
#   operating_system_version = "22.04"
#   # operating_system_version = "22.04 Minimal"
#   # operating_system_version = "20.04"
#   # operating_system_version = "18.04"
#   shape      = var.instance_shape
#   sort_by    = "TIMECREATED"
#   sort_order = "DESC"
# }

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

