/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

# Load Balancer
resource "oci_load_balancer_load_balancer" "lb" {
  shape          = var.load_balancer_shape
  compartment_id = var.compartment_ocid
  subnet_ids     = [var.load_balancer_subnet]
  display_name  = var.load_balancer_name
  is_private    = var.load_balancer_private
  freeform_tags = var.freeform_tags
}

# Load Balancer Backendset
resource "oci_load_balancer_backend_set" "lb-bset" {
  depends_on = [oci_load_balancer_load_balancer.lb]
  name             = "${var.load_balancer_name}-bes"
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = var.compute_instance_listen_port
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
  session_persistence_configuration {
    cookie_name      = "lb-sessprs"
    disable_fallback = true
  }


}

# Load Balancer Backend
resource "oci_load_balancer_backend" "lb-bset-be" {
  depends_on = [
    oci_load_balancer_load_balancer.lb,
    oci_load_balancer_backend_set.lb-bset,
  ]
  count            = var.compute_instance_count
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  backendset_name  = oci_load_balancer_backend_set.lb-bset.name
  ip_address       = element(var.be_ip_addresses, count.index)
  port             = var.compute_instance_listen_port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

# Load Balancer Hostname
resource "oci_load_balancer_hostname" "hostname" {
  depends_on       = [oci_load_balancer_load_balancer.lb]
  hostname         = var.load_balancer_hostname
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  name             = "ebs-hostname"
}

# Load Balancer Listener
resource "oci_load_balancer_listener" "lb-listener" {
  depends_on = [
    oci_load_balancer_load_balancer.lb,
    oci_load_balancer_backend_set.lb-bset,
    oci_load_balancer_hostname.hostname,
  ]
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "${var.load_balancer_name}-lsnr"
  default_backend_set_name = oci_load_balancer_backend_set.lb-bset.name
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  hostname_names = [oci_load_balancer_hostname.hostname.name]
  port           = var.load_balancer_listen_port
  protocol       = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

output "LoadbalancerIP" {
  description = "Load balancer IP"
  value       = oci_load_balancer_load_balancer.lb.ip_addresses
}