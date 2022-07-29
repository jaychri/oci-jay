variable "maven_cidr" {
  default     = ""
  description = "local address to allow access from"
}

resource "oci_core_security_list" "base_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.base_vcn.id
  display_name   = "baseSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
    description = "Wildcard TCP exit"

  }

  # -------------------- Default ICMP rules ------------------------

  ingress_security_rules {
    description = "ANY ICMP controls"
    icmp_options {
      type = 3
      code = 4
    }
    protocol = 1
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
    description = "Internal ICMP controls"
    icmp_options {
      type = 3
    }
    protocol = 1
    source   = "10.1.0.0/16"
  }


  # ingress_security_rules {
  #   description = "ANY SSH inbound"
  #   tcp_options {
  #     max = "22"
  #     min = "22"
  #   }
  #   protocol    = "6"
  #   source      = "0.0.0.0/0"
  # }  

  # -------  MAVEN  ----------------------------------------------

  ingress_security_rules {
    description = "Maven SSH inbound"
    tcp_options {
      max = "22"
      min = "22"
    }
    protocol = "6"
    source   = var.maven_cidr
  }

  ingress_security_rules {
    description = "Maven ICMP inbound"
    protocol    = 1
    source      = var.maven_cidr
  }

  # ingress_security_rules {
  #   description = "Maven WILDCARD"
  #   protocol    = "All"
  #   source      = var.maven_cidr
  # }


  #  defaults 
  #   Protocol = all, 1-icmp, 6-tcp, 17-udp

}
