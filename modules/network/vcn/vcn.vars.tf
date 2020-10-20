/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

variable "compartment_ocid" {
  description = "Compartment OCID"
}

# VCN Variables
variable "vcn_cidr" {
  description = "VCN CIDR"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
}

variable "freeform_tags" {
  type = map(any)
  default = {
    environment = "dev"
  }
}

variable "ebs_app_instance_listen_port" {}

variable "load_balancer_listen_port" {}