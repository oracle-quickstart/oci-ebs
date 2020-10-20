/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

variable "compartment_ocid" {
  description = "Compartment name"
}

variable "availability_domain" {
  description = "Availability domain"
  type        = list(string)
}

variable "fault_domain" {
  description = "Fault Domain"
  type        = list(string)
}
/*
variable "AD" {
  description = "Availability domain"
  type        = list(string)
}*/

# Bastion host variables
variable "bastion_hostname_prefix" {
  description = "Prefix for bastion hostname"
}

variable "bastion_instance_shape" {
  description = "Instance shape of bastion host"
}

variable "bastion_subnet" {
  description = "Subnet for Bastion host"
}

variable "bastion_image" {
  description = "Bation Operating System Image"
}

variable "bastion_ssh_public_key" {
  description = "Bastion Host SSH public key"
}

variable "freeform_tags" {
  type = map(any)
  default = {
    environment = "dev"
  }
}
