/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/


resource "oci_database_db_system" "database" {
  count               = "${var.db_instance_count}"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${element(var.availability_domain, 0)}"
  fault_domains       = ["${var.fault_domain}"]
#  cpu_core_count      = "${lookup(data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0], "minimum_core_count")}"
  database_edition    = "${var.db_edition}"
  shape                   = "${var.db_instance_shape}"
  node_count              = "${var.db_node_count}"
  data_storage_size_in_gb = "${var.db_size_in_gb}"
  license_model           = "${var.db_license_model}"
  disk_redundancy         = "${var.db_disk_redundancy}"
  subnet_id               = "${var.db_subnet}"
  ssh_public_keys         =  ["${var.db_ssh_public_key}"]
  display_name            = "${var.db_name}"
  hostname                = "${var.db_hostname_prefix}${element(var.AD, 0)}"
  time_zone               = "${var.timezone}"

  db_home {
    database {
      "admin_password"  = "${var.db_admin_password}"
      "db_name"         = "${var.db_name}"   
      "character_set"   = "${var.db_characterset}"
      "ncharacter_set"  = "${var.db_nls_characterset}"
      "db_workload"     = "${var.db_workload}"
      "pdb_name"        = "${var.db_pdb_name}"

      db_backup_config {
        auto_backup_enabled     = "${var.db_autobackup_enabled}"
        recovery_window_in_days = "${var.db_autobackup_recovery_window}"
      }
    }
    db_version    = "${var.db_version}"
    display_name  = "${var.db_name}"
  }
  
  lifecycle {
    ignore_changes = ["fault_domains"]
  }

  timeouts {
    create = "${var.timeout}"
  }

}

locals {
        enable_dg       = "${length(var.availability_domain) >= "2" && var.db_instance_count == 1 ? 1 : 0}"
}

resource "oci_database_data_guard_association" "database_data_guard_association" {
  count                             = "${local.enable_dg ? 1 : 0}"
  creation_type                     = "NewDbSystem"
  database_admin_password           = "${var.db_admin_password}"
  database_id                       = "${data.oci_database_databases.db.databases.0.id}"
  protection_mode                   = "MAXIMUM_PERFORMANCE"
  transport_type                    = "ASYNC"
  delete_standby_db_home_on_delete  = "true"

  #required for NewDbSystem creation_type
  display_name        = "${var.db_name}-dg"
  shape               = "${var.db_instance_shape}"
  subnet_id           = "${var.db_subnet}"
  availability_domain = "${element(var.availability_domain, 1)}"
  hostname            = "${var.db_hostname_prefix}${element(var.AD, 1)}"

  timeouts {
    create = "${var.timeout}"
  }
}
