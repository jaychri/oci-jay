variable "instance1_hostname" {
  default = "int1"
}

variable "instance1_shape" {
  # default = "VM.Standard.A1.Flex" # Ampere 
  default = "VM.Standard.E2.1.Micro"
}

variable "instance1_ocpus" {
  default = 1
}

variable "instance1_mem" {
  default     = 1
  description = "memory in Gig"
}

# ---------------------------------------------------------------------------------------------------

resource "oci_core_instance" "instance1" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance1_hostname
  shape               = var.instance1_shape

  shape_config {
    ocpus         = var.instance1_ocpus
    memory_in_gbs = var.instance1_mem
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.test_subnet.id
    display_name     = "${var.instance1_hostname}-nic"
    assign_public_ip = true
    hostname_label   = var.instance1_hostname
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.instance1_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
  }
}

output "instance1" {
  value = "ssh -i ../key.pem ubuntu@${oci_core_instance.instance1.public_ip}  #instance1 ${var.instance1_hostname}"
}


data "oci_core_images" "instance1_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  # operating_system_version = "22.04 Minimal"
  # operating_system_version = "20.04"
  # operating_system_version = "18.04"
  shape      = var.instance1_shape
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

# # See https://docs.oracle.com/iaas/images/
# data "oci_core_images" "instance1_images" {
#   compartment_id           = var.compartment_ocid
#   operating_system         = "Oracle Linux"
#   operating_system_version = "8"
#   shape                    = var.instance1_shape
#   sort_by                  = "TIMECREATED"
#   sort_order               = "DESC"
# }