variable "instance_int1_hostname" {
  default = "int1"
}

variable "instance_int1_shape" {
  # default = "VM.Standard.A1.Flex" # Ampere 
  default = "VM.Standard.E2.1.Micro"
}

variable "instance_int1_ocpus" {
  default = 1
}

variable "instance_int1_mem" {
  default     = 1
  description = "memory in Gig"
}

# ---------------------------------------------------------------------------------------------------

resource "oci_core_instance" "instance_int1" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_int1_hostname
  shape               = var.instance_int1_shape

  shape_config {
    ocpus         = var.instance_int1_ocpus
    memory_in_gbs = var.instance_int1_mem
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.base_subnet.id
    display_name     = "${var.instance_int1_hostname}-nic"
    assign_public_ip = true
    hostname_label   = var.instance_int1_hostname
    nsg_ids          = [oci_core_network_security_group.nsg_all.id]
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.instance_int1_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
  }
}

output "instance_int1" {
  value = "ssh -i ../key.pem ubuntu@${oci_core_instance.instance_int1.public_ip}  #instance_int1 ${var.instance_int1_hostname}"
}


data "oci_core_images" "instance_int1_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  # operating_system_version = "22.04 Minimal"
  # operating_system_version = "20.04"
  # operating_system_version = "18.04"
  shape      = var.instance_int1_shape
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

# # See https://docs.oracle.com/iaas/images/
# data "oci_core_images" "instance_int1_images" {
#   compartment_id           = var.compartment_ocid
#   operating_system         = "Oracle Linux"
#   operating_system_version = "8"
#   shape                    = var.instance_int1_shape
#   sort_by                  = "TIMECREATED"
#   sort_order               = "DESC"
# }
