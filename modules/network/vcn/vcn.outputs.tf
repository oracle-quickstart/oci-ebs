/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

output "vcnid" {
  description = "ocid of VCN"
  value       = oci_core_virtual_network.vcn.id
}

output "default_dhcp_id" {
  description = "ocid of default DHCP options"
  value       = oci_core_virtual_network.vcn.default_dhcp_options_id
}

output "igw_id" {
  description = "ocid of internet gateway"
  value       = oci_core_internet_gateway.igw.id
}

output "natgtw_id" {
  description = "ocid of service gateway"
  value       = oci_core_nat_gateway.natgtw.id
}

output "svcgtw_id" {
  description = "ocid of service gateway"
  value       = oci_core_service_gateway.svcgtw.id
}

output "publicrt_id" {
  value = oci_core_route_table.PublicRT.id
}

output "privatert_id" {
  value = oci_core_route_table.PrivateRT.id
}

output "bastionseclist_id" {
  value = oci_core_security_list.BastionSecList.id
}

output "appseclist_id" {
  value = oci_core_security_list.AppSecList.id
}

output "dbseclist_id" {
  value = oci_core_security_list.DBSecList.id
}

output "lbseclist_id" {
  value = oci_core_security_list.LBSecList.id
}