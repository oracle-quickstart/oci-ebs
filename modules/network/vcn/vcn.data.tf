/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# Get name of object storage 
data "oci_core_services" "svcgtw_services" {
  filter {
    name   = "name"
    values = [".*Oracle.*Services*"]
    regex  = true
  }
}

