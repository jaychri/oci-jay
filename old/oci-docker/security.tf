
# resource "oci_core_network_security_group_security_rule" "nsg_outbound" {
#   network_security_group_id = oci_core_network_security_group.nsg.id
#   direction                 = "EGRESS"
#   protocol                  = "all"
#   description               = "nsg-${var.hostname}-outbound"
#   destination               = "0.0.0.0/0"
#   destination_type          = "CIDR_BLOCK"
# }

# create empty security list to avoid using 'default' with open 22
# resource "oci_core_security_list" "empty_security_list" {
#   compartment_id = oci_identity_compartment.compartment.id
#   vcn_id         = oci_core_vcn.vcn.id
#   display_name   = "seclist-${var.hostname}"
# }

# resource "oci_core_network_security_group" "nsg" {
#   compartment_id = oci_identity_compartment.compartment.id
#   vcn_id         = oci_core_vcn.vcn.id
#   display_name   = "nsg-${var.hostname}"
# }

# resource "oci_core_network_security_group_security_rule" "nsg_inbound_ssh" {
#   network_security_group_id = oci_core_network_security_group.nsg.id
#   direction                 = "INGRESS"
#   protocol                  = "6" # TCP
#   description               = "nsg-${var.hostname}-inbound-ssh"
#   source                    = ""
#   source_type               = "CIDR_BLOCK"
# #   destination               = "${module.vminst.public_ip}/32"
#   destination_type          = "CIDR_BLOCK"
#   tcp_options {
#     destination_port_range {
#       min = 22
#       max = 22
#     }
#   }
# }
