/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/


# Create subnet
resource "oci_core_subnet" "subnet" {
  compartment_id              = "${var.compartment_ocid}" 
  vcn_id                      = "${var.vcn_id}"
  cidr_block                  = "${var.vcn_subnet_cidr}"
  display_name                = "${var.dns_label}"
  dns_label                   = "${var.dns_label}"
  dhcp_options_id             = "${var.dhcp_options_id}"
  route_table_id              = "${var.route_table_id}"
  security_list_ids           = ["${var.security_list_ids}"]
  prohibit_public_ip_on_vnic  = "${var.private_subnet}"
}