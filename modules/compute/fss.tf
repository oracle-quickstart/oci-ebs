/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# Filesystem
resource "oci_file_storage_file_system" "fss" {
  count               = length(var.availability_domain)
  compartment_id      = var.compartment_ocid
  availability_domain = element(var.availability_domain, count.index)
  display_name        = "${var.fss_instance_prefix}${substr(element(var.availability_domain, count.index), -1, 1)}"

  freeform_tags = var.freeform_tags
}

# Mount Target
resource "oci_file_storage_mount_target" "fss_mt" {
  depends_on          = [oci_file_storage_file_system.fss]
  count               = length(var.availability_domain)
  compartment_id      = var.compartment_ocid
  availability_domain = element(var.availability_domain, count.index)
  hostname_label      = "${var.fss_instance_prefix}${substr(element(var.availability_domain, count.index), -1, 1)}"

  subnet_id     = var.fss_subnet
  display_name  = "${var.fss_instance_prefix}${substr(element(var.availability_domain, count.index), -1, 1)}_mt"
  freeform_tags = var.freeform_tags
}

# Filesystem exportset
resource "oci_file_storage_export_set" "fss_expset" {
  depends_on = [
    oci_file_storage_file_system.fss,
    oci_file_storage_mount_target.fss_mt,
  ]
  count             = length(var.availability_domain)
  mount_target_id   = element(oci_file_storage_mount_target.fss_mt.*.id, count.index)
  max_fs_stat_bytes = var.fss_limit_size_in_gb * 1024 * 1024 * 1024
}

# Filesystem export
resource "oci_file_storage_export" "fss_exp" {
  depends_on = [
    oci_file_storage_file_system.fss,
    oci_file_storage_mount_target.fss_mt,
  ]
  count = length(var.availability_domain)
  export_set_id = element(
    oci_file_storage_mount_target.fss_mt.*.export_set_id,
    count.index,
  )
  file_system_id = element(oci_file_storage_file_system.fss.*.id, count.index)
  #path           = "/${var.fss_instance_prefix}${var.AD[count.index]}"
  path = "/${var.fss_instance_prefix}${substr(var.availability_domain[count.index], -1, 1)}"

  export_options {
    source                         = "0.0.0.0/0"
    access                         = "READ_WRITE"
    identity_squash                = "NONE"
    require_privileged_source_port = false
  }
}

