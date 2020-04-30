/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/


variable "tenancy_ocid" {}

variable "region" {}

#variable "user_ocid" {}

#variable "fingerprint" {}

#variable "private_key_path" {}

variable "compartment_ocid" {}

variable "AD" {
    description = "Availability domain number"
    type        = "list"
    default     = ["1"]
}

variable "ssh_public_key" {
    description = "SSH public key for instances"
}

variable "ssh_private_key" {
    description = "SSH private key for instances"
}  

variable "bastion_ssh_public_key" {
    description = "SSH public key for bastion instance"
}

variable "bastion_ssh_private_key" {
    description = "SSH private key for bastion_instance"
}  

variable "InstanceOS" {
    description = "Operating system for compute instances"
    default     = "Oracle Linux" 
}

variable "linux_os_version" {
    description = "Operating system version for compute instances except NAT"
    default     = "7"
}

# VCN variables
variable "vcn_cidr" {
    description = "CIDR for Virtual Cloud Network (VCN)"
}
variable "vcn_dns_label" {
    description = "DNS label for Virtual Cloud Network (VCN)"
}

# Bastion host variables
variable "bastion_instance_shape" {
    description = "Instance shape of bastion host"
    default     = "VM.Standard2.1"
}

# Application Server variables
variable "ebs_env_prefix" {
}

variable "ebs_app_instance_count" {
    description = "Application Server count"
}

variable "ebs_app_instance_shape" {
    description = "Application Instance shape"
}

variable "ebs_app_instance_listen_port" {
    description = "Application instance listen port"
}

variable "ebs_shared_filesystem_mount_path" {
    description = "Mountpoint for primary application servers"
}

variable "ebs_shared_filesystem_size_limit_in_gb" {
    description = "Mountpoint for primary application servers"
    default     = "500"
}

variable "ebs_app_boot_volume_size_in_gb" {
    description = "Boot volume size of application servers"
}

variable "ebs_app_block_volume_size_in_gb" {
    description = "Block volume size of application servers"
}

variable "ebs_app_block_volume_vpus_per_gb" {
    description = "Block volume VPUs"
}

variable "ebs_app_block_volume_mount_path" {
    description = "Block Volume Mountpoint for primary application servers"
}

variable "timezone" {
    description = "Set timezone for servers"
}

# Database variables

variable "ebs_database_required" {
    description = "DB Edition"
    default     = "true"
}

variable "db_edition" {
    description = "DB Edition"
    default     = "ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
}

variable "db_instance_shape" {
    description = "DB Instance shape"
    default     = "VM.Standard2.2"
}

variable "db_node_count" {
    description = "Number of DB Nodes"
    default     = "2"
}

variable "db_size_in_gb" {
    description = "Size of database in GB"
    default     = "256"
}

variable "db_license_model" {
    description = "Database License model"
    default     = "LICENSE_INCLUDED"
}

variable "db_admin_password" {
    description = "Database Admin password"
    default     = ""
}

variable "db_name" {
    description = "Database Name"
    default     = "EBSCDB"
}

variable "db_characterset" {
    description = "Database Characterset"
    default     = "AL32UTF8"
}

variable "db_nls_characterset" {
    description = "Database National Characterset"
    default     = "AL16UTF16"
}

variable "db_version" {
    description = "Database version"
    default     = "12.1.0.2"  
}

variable "db_pdb_name" {
    description = "Pluggable database Name" 
    default     = "EBSDB"   
}

variable "database_autobackup_recovery_window" {
    description = "Database License model"
    default     = "30"
}

variable "database_autobackup_enabled" {
    description = "Enable database Autobackup"
    default     = true
}

variable load_balancer_shape {
    description = "Load Balancer shape"
}

variable load_balancer_private {
    description = "Whether private Load balancer"
    default     = true
}

variable load_balancer_hostname {
    description = "Load Balancer hostname"
}

variable load_balancer_listen_port {
    description = "Load balancer listen port"
}

variable "timeout" {
  description = "Timeout setting for resource creation"
  default     = "10m"
}

variable "compute_instance_user" {
  description = "Login user for application instance"
  default     = "opc"
}

variable "bastion_user" {
  description = "Login user for bastion host"
  default     = "opc"
}
