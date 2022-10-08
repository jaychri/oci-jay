
resource "oci_core_network_security_group" "nsg_all" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.base_vcn.id
  display_name   = "nsg_all"
}

resource "oci_core_network_security_group_security_rule" "rule_egress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_all.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "rule_ingress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_all.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = "10.1.0.0/16"
}
