/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

output "BastionPublicIPs" {
  value       = module.create_bastion.Bastion_Public_IPs
  description = "Public IPs of Bastion Host"
}

output "ApplicationPrivateIPs" {
  value       = module.create_app.AppsPrvIPs
  description = "Private IPs of EBS Application Server(s)"
}

output "LoadBalancerIP" {
  value       = module.create_lb.LoadbalancerIP
  description = "IP of Load Balancer"
}
output "FSSDetails" {
  value       = module.create_app.FSSFstabs
  description = "Shared File system Details"
}

output "DatabaseSystemConnectionString" {
  value       = module.create_db.dbcon
  description = "Database Connection String"
}

