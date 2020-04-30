/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/


locals {
  tcp_protocol  = "6"
  udp_protocol  = "17"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
  db_port       = "1521"
  ssh_port      = "22"
  app_ports     = ["7201","7202","7401","7402","7601", "7602","7001","7002"]
  fss_ports     = ["2048","2050","111"]
  ora_svcs_port = "443"
}

# Bastion Security List
resource "oci_core_security_list" "BastionSecList" {
    compartment_id  = "${var.compartment_ocid}"
    display_name    = "BastionSecList"
    vcn_id          = "${module.create_vcn.vcnid}"

    egress_security_rules = [
        {
        protocol    = "${local.tcp_protocol}"
        destination = "${local.anywhere}"
        },
    ]

    ingress_security_rules = [
        {
        tcp_options {
            "min" = "${local.ssh_port}"
            "max" = "${local.ssh_port}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${local.anywhere}"
        },
    ]
}

# Database System Security List
resource "oci_core_security_list" "DBSecList" {
    compartment_id  = "${var.compartment_ocid}"
    display_name    = "DBSecList"
    vcn_id          = "${module.create_vcn.vcnid}"

    egress_security_rules = [
        {
        protocol    = "${local.tcp_protocol}"
        destination = "${local.anywhere}"
        },
        {
        tcp_options {
            "min" = "${local.ora_svcs_port}"
            "max" = "${local.ora_svcs_port}"
        }
        protocol         = "${local.tcp_protocol}"
        destination      = "${lookup(data.oci_core_services.svcgtw_services.services[0], "cidr_block")}"
        destination_type = "SERVICE_CIDR_BLOCK"
        }
    ]

    ingress_security_rules = [
        {
        tcp_options {
            "min" = "${local.ssh_port}"
            "max" = "${local.ssh_port}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            "min" = "${local.db_port}"
            "max" = "${local.db_port}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
    ]
}

# Application Security List
resource "oci_core_security_list" "AppSecList" {
    compartment_id  = "${var.compartment_ocid}"
    display_name    = "AppSecList"
    vcn_id          = "${module.create_vcn.vcnid}"

    egress_security_rules = [
        {
        protocol    = "${local.tcp_protocol}"
        destination = "${local.anywhere}"
        },
        {
        tcp_options {
            "min" = "${local.ora_svcs_port}"
            "max" = "${local.ora_svcs_port}"
        }
        protocol            = "${local.tcp_protocol}"
        destination         = "${lookup(data.oci_core_services.svcgtw_services.services[0], "cidr_block")}"
        destination_type    = "SERVICE_CIDR_BLOCK"
        },
        {
        tcp_options {
            source_port_range {
                #Required
                min = "${local.fss_ports[0]}"
                max = "${local.fss_ports[1]}"
            }
        }

        protocol        = "${local.tcp_protocol}"
        destination     = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            source_port_range {
                #Required
                min = "${local.fss_ports[2]}"
                max = "${local.fss_ports[2]}"
            }
        }

        protocol        = "${local.tcp_protocol}"
        destination     = "${var.vcn_cidr}"
        },
        {
        udp_options {
            source_port_range {
                #Required
                min = "${local.fss_ports[2]}"
                max = "${local.fss_ports[2]}"
            }        
        }

        protocol        = "${local.udp_protocol}"
        destination     = "${var.vcn_cidr}"
        }       
    ]

    ingress_security_rules = [
        {
        tcp_options {
            "min" = "${local.ssh_port}"
            "max" = "${local.ssh_port}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            "min" = "${var.ebs_app_instance_listen_port}"
            "max" = "${var.ebs_app_instance_listen_port}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            "min" = "${local.app_ports[0]}"
            "max" = "${local.app_ports[1]}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            "min" = "${local.app_ports[2]}"
            "max" = "${local.app_ports[3]}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            "min" = "${local.app_ports[4]}"
            "max" = "${local.app_ports[5]}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            "min" = "${local.app_ports[6]}"
            "max" = "${local.app_ports[7]}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },   
        {
        tcp_options {
            "min" = "${local.fss_ports[0]}"
            "max" = "${local.fss_ports[1]}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        tcp_options {
            "min" = "${local.fss_ports[2]}"
            "max" = "${local.fss_ports[2]}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        udp_options {
            "min" = "${local.fss_ports[0]}"
            "max" = "${local.fss_ports[0]}"
        }

        protocol = "${local.udp_protocol}"
        source   = "${var.vcn_cidr}"
        },
        {
        udp_options {
            "min" = "${local.fss_ports[2]}"
            "max" = "${local.fss_ports[2]}"
        }

        protocol = "${local.udp_protocol}"
        source   = "${var.vcn_cidr}"
        },
    ]
}

# Load Balancer Security List
resource "oci_core_security_list" "LBSecList" {
    compartment_id  = "${var.compartment_ocid}"
    display_name    = "LBSecList"
    vcn_id          = "${module.create_vcn.vcnid}"

    egress_security_rules = [
        {
        protocol    = "${local.tcp_protocol}"
        destination = "${local.anywhere}"
        },
    ]

    ingress_security_rules = [
        {
        tcp_options {
            "min" = "${var.load_balancer_listen_port}"
            "max" = "${var.load_balancer_listen_port}"
        }

        protocol = "${local.tcp_protocol}"
        source   = "${local.anywhere}"
        },
    ]
}


