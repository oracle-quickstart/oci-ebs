/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

resource "random_integer" "rand" {
  min = 1000000000
  max = 9999999999
}

locals {
  enable_rsync = length(var.availability_domain) >= "2" ? true : false
}

# Enable rsync
resource "null_resource" "enable_rsync" {
  depends_on = [
    oci_core_instance.compute,
    oci_file_storage_export.fss_exp,
  ]
  count = local.enable_rsync ? var.compute_instance_count : 0

  provisioner "file" {
    connection {
      agent       = false
      timeout     = var.timeout
      host        = oci_core_instance.compute[count.index % var.compute_instance_count].private_ip
      user        = var.compute_instance_user
      private_key = var.compute_ssh_private_key

      bastion_host        = var.bastion_public_ip
      bastion_user        = var.bastion_user
      bastion_private_key = var.bastion_ssh_private_key

    }

    content     = data.template_file.rsync[0].rendered
    destination = "${var.tmpdir}/rsync_${random_integer.rand.result}.sh"
  }

  provisioner "local-exec" {
    command = "sleep 120" # Wait for cloud-init to complete
  }

  provisioner "remote-exec" {
    connection {
      agent   = false
      timeout = var.timeout
      host    = oci_core_instance.compute[count.index % var.compute_instance_count].private_ip
      user    = var.compute_instance_user

      #      private_key         = "${file("${var.compute_ssh_private_key}")}"
      private_key = var.compute_ssh_private_key

      bastion_host        = var.bastion_public_ip
      bastion_user        = var.bastion_user
      bastion_private_key = var.bastion_ssh_private_key

    }

    inline = [
      "chmod +x  ${var.tmpdir}/rsync_${random_integer.rand.result}.sh",
      "while [ ! -f ${var.tmpdir}/rsync.done ]; do ${var.tmpdir}/rsync_${random_integer.rand.result}.sh; sleep 10; done",
    ]
  }
}

