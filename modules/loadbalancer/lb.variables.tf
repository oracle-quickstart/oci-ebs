/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# General Variables 
variable "compartment_ocid" {
  description = "Compartment name"
}

variable "availability_domain" {
  description = "Availability domain"
  type        = list(string)
}
/*
variable "AD" {
  description = "Availability domain"
  type        = list(string)
}
*/
# Load Balancer variables
variable "load_balancer_subnet" {
  description = "Subnet for Load Balancer"
}

variable "load_balancer_name" {
  description = "Name of Load Balancer"
}

variable "load_balancer_shape" {
  description = "Shape of Load Balancer"
}

variable "load_balancer_private" {
  description = "Set private load balacer"
  default     = "True"
}

variable "be_ip_addresses" {
  description = "Backend IP addresses"
  type        = list(string)
}

variable "load_balancer_hostname" {
  description = "Hostname for Load Balancer"
}

variable "compute_instance_listen_port" {
  description = "Listen port of compute instance"
}

variable "load_balancer_listen_port" {
  description = "Listen port of Load Balancer"
}

variable "compute_instance_count" {
  description = "Number or compute instances"
}

variable "freeform_tags" {
  type = map(any)
  default = {
    environment = "dev"
  }
}

