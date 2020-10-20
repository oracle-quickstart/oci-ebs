/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# Virtual Cloud Network (VCN)
resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr
  dns_label      = var.vcn_dns_label
  display_name   = var.vcn_dns_label
  freeform_tags  = var.freeform_tags
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.vcn_dns_label}igw"
  freeform_tags  = var.freeform_tags
}

# NAT (Network Address Translation) Gateway
resource "oci_core_nat_gateway" "natgtw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.vcn_dns_label}natgtw"
  freeform_tags  = var.freeform_tags
}

# Service Gateway
resource "oci_core_service_gateway" "svcgtw" {
  compartment_id = var.compartment_ocid

  services {
    service_id = data.oci_core_services.svcgtw_services.services[0]["id"]
  }
  vcn_id        = oci_core_virtual_network.vcn.id
  display_name  = "${var.vcn_dns_label}svcgtw"
  freeform_tags = var.freeform_tags
}
/*
# Dynamic Routing Gateway (DRG)
resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}drg"
  freeform_tags = var.freeform_tags
}

resource "oci_core_drg_attachment" "drg_attachment" {
  drg_id       = oci_core_drg.drg.id
  vcn_id       = oci_core_virtual_network.vcn.id
  display_name = "${var.vcn_dns_label}drgattchmt"
}*/
/*
locals {
  anywhere = "0.0.0.0/0"
}*/

locals {
  tcp_protocol  = "6"
  udp_protocol  = "17"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
  db_port       = "1521"
  ssh_port      = "22"
  app_ports     = ["7201", "7202", "7401", "7402", "7601", "7602", "7001", "7002"]
  fss_ports     = ["2048", "2050", "111"]
  ora_svcs_port = "443"
}
# Public Route Table
resource "oci_core_route_table" "PublicRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.vcn_dns_label}pubrt"
  freeform_tags  = var.freeform_tags
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    description       = "Route rule for Internet Traffic"
    destination_type  = "CIDR_BLOCK"
    destination       = local.anywhere
  }
}

# Private Route Table
resource "oci_core_route_table" "PrivateRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.vcn_dns_label}pvtrt"
  freeform_tags  = var.freeform_tags
  route_rules {
    network_entity_id = oci_core_nat_gateway.natgtw.id
    description       = "Route rule for Nat gateway"
    destination_type  = "CIDR_BLOCK"
    destination       = local.anywhere
  }
  route_rules {
    network_entity_id = oci_core_service_gateway.svcgtw.id
    description       = "Route rule for Service Gateway"
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = data.oci_core_services.svcgtw_services.services[0].cidr_block
  }
}

# Bastion Security List
resource "oci_core_security_list" "BastionSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "BastionSecList"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    protocol    = local.tcp_protocol
    destination = local.anywhere
  }

  ingress_security_rules {
    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }

    protocol = local.tcp_protocol
    source   = local.anywhere
  }
}

# Database System Security List
resource "oci_core_security_list" "DBSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "DBSecList"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    protocol    = local.tcp_protocol
    destination = local.anywhere
  }
  egress_security_rules {
    tcp_options {
      min = local.ora_svcs_port
      max = local.ora_svcs_port
    }
    protocol         = local.tcp_protocol
    destination      = data.oci_core_services.svcgtw_services.services[0]["cidr_block"]
    destination_type = "SERVICE_CIDR_BLOCK"
  }

  ingress_security_rules {
    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = local.db_port
      max = local.db_port
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
}

# Application Security List
resource "oci_core_security_list" "AppSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "AppSecList"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    protocol    = local.tcp_protocol
    destination = local.anywhere
  }
  egress_security_rules {
    tcp_options {
      min = local.ora_svcs_port
      max = local.ora_svcs_port
    }
    protocol         = local.tcp_protocol
    destination      = data.oci_core_services.svcgtw_services.services[0]["cidr_block"]
    destination_type = "SERVICE_CIDR_BLOCK"
  }
  egress_security_rules {
    tcp_options {
      source_port_range {
        #Required
        min = local.fss_ports[0]
        max = local.fss_ports[1]
      }
    }

    protocol    = local.tcp_protocol
    destination = var.vcn_cidr
  }
  egress_security_rules {
    tcp_options {
      source_port_range {
        #Required
        min = local.fss_ports[2]
        max = local.fss_ports[2]
      }
    }

    protocol    = local.tcp_protocol
    destination = var.vcn_cidr
  }
  egress_security_rules {
    udp_options {
      source_port_range {
        #Required
        min = local.fss_ports[2]
        max = local.fss_ports[2]
      }
    }

    protocol    = local.udp_protocol
    destination = var.vcn_cidr
  }

  ingress_security_rules {
    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = var.ebs_app_instance_listen_port
      max = var.ebs_app_instance_listen_port
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = local.app_ports[0]
      max = local.app_ports[1]
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = local.app_ports[2]
      max = local.app_ports[3]
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = local.app_ports[4]
      max = local.app_ports[5]
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = local.app_ports[6]
      max = local.app_ports[7]
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = local.fss_ports[0]
      max = local.fss_ports[1]
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    tcp_options {
      min = local.fss_ports[2]
      max = local.fss_ports[2]
    }

    protocol = local.tcp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    udp_options {
      min = local.fss_ports[0]
      max = local.fss_ports[0]
    }

    protocol = local.udp_protocol
    source   = var.vcn_cidr
  }
  ingress_security_rules {
    udp_options {
      min = local.fss_ports[2]
      max = local.fss_ports[2]
    }

    protocol = local.udp_protocol
    source   = var.vcn_cidr
  }
}

# Load Balancer Security List
resource "oci_core_security_list" "LBSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "LBSecList"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    protocol    = local.tcp_protocol
    destination = local.anywhere
  }

  ingress_security_rules {
    tcp_options {
      min = var.load_balancer_listen_port
      max = var.load_balancer_listen_port
    }

    protocol = local.tcp_protocol
    source   = local.anywhere
  }
}


