/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# Terraform version

terraform {
  required_version = ">=0.12"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "=3.93.0"
    }
  }
}

# Oracle Cloud Infrastructure (OCI) Provider
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  #  user_ocid        = var.user_ocid
  #  private_key_path = var.private_key_path
  #  fingerprint      = var.fingerprint
  region = var.region
}
