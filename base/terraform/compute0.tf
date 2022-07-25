variable "instance0_hostname" {
  default = "arm1"
}

variable "instance0_shape" {
  default = "VM.Standard.A1.Flex" # Ampere 
  # default = "VM.Standard.E2.1.Micro"
}

variable "instance0_ocpus" {
  default = 2
}

variable "instance0_mem" {
  default     = 12
  description = "memory in Gig"
}

# ---------------------------------------------------------------------------------------------------

resource "oci_core_instance" "instance0" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance0_hostname
  shape               = var.instance0_shape

  shape_config {
    ocpus         = var.instance0_ocpus
    memory_in_gbs = var.instance0_mem
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.test_subnet.id
    display_name     = "${var.instance0_hostname}-nic"
    assign_public_ip = true
    hostname_label   = var.instance0_hostname
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.instance0_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
  }
}

output "instance0" {
  value = "ssh -i key.pem ubuntu@${oci_core_instance.instance0.public_ip}  #instance0 ${var.instance0_hostname}"
}


data "oci_core_images" "instance0_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  # operating_system_version = "22.04 Minimal"
  # operating_system_version = "20.04"
  # operating_system_version = "18.04"
  shape      = var.instance0_shape
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}
