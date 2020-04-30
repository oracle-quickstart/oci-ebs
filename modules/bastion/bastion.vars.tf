/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/


variable "compartment_ocid" {
    description = "Compartment name"
}

variable "availability_domain" {
    description = "Availability domain"
    type        = "list"
}

variable "fault_domain" {
  description = "Fault Domainr"
  type        = "list"
}

variable "AD" {
    description = "Availability domain"
    type= "list"
}

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
    description ="Bation Operating System Image"
}

variable "bastion_ssh_public_key" {
    description = "Bastion Host SSH public key"
}
