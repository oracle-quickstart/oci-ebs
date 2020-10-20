/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# Get CPU and node and node count for a db shape
/*data "oci_database_db_system_shapes" "db_system_shapes" {
	availability_domain = "${element(var.availability_domain, count.index)}"
	compartment_id = "${var.compartment_ocid}"
    filter {
        name = "name"
        values = ["${var.db_instance_shape}"]
    }
}*/

# Get database homes
data "oci_database_db_homes" "dbhomes" {
  count          = var.db_instance_count
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.database[0].id

  filter {
    name   = "display_name"
    values = [var.db_name]
  }
}

# Get databases in database home
data "oci_database_databases" "db" {
  count          = var.db_instance_count
  compartment_id = var.compartment_ocid
  db_home_id     = data.oci_database_db_homes.dbhomes[0].db_homes[0].db_home_id
}
