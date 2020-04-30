/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# Terraform version

terraform {
  required_version = "<0.12.0"
}

# Oracle Cloud Infrastructure (OCI) Provider

provider "oci" {
  version           = "=3.70.0"
  tenancy_ocid      = "${var.tenancy_ocid}"
#  user_ocid         = "${var.user_ocid}"
#  fingerprint       = "${var.fingerprint}"
#  private_key_path  = "${var.private_key_path}"
  region            = "${var.region}"
 }
