/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

resource "oci_core_volume" "blockvolume" {
  count               = var.compute_instance_count
  availability_domain = element(var.availability_domain, count.index)
  compartment_id      = var.compartment_ocid
  display_name        = "${var.compute_hostname_prefix}vol${count.index + 1}"
  size_in_gbs         = var.compute_block_volume_size_in_gb
  vpus_per_gb         = var.compute_block_volume_vpus_per_gb
  freeform_tags       = var.freeform_tags
}

resource "oci_core_volume_attachment" "blockvolume_attach" {
  attachment_type = "iscsi"
  count           = var.compute_instance_count

  #  compartment_id  = "${var.compartment_ocid}"
  instance_id = element(oci_core_instance.compute.*.id, count.index)
  volume_id   = element(oci_core_volume.blockvolume.*.id, count.index)


  provisioner "remote-exec" {
    connection {
      agent   = false
      timeout = "30m"
      host    = element(oci_core_instance.compute.*.private_ip, count.index)
      user    = var.compute_instance_user

      #      private_key         = "${file("${var.compute_ssh_private_key}")}"
      private_key = var.compute_ssh_private_key

      bastion_host        = var.bastion_public_ip
      bastion_port        = "22"
      bastion_user        = var.bastion_user
      bastion_private_key = var.bastion_ssh_private_key

    }

    inline = [
      "sudo -s bash -c 'iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}'",
      "sudo -s bash -c 'iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic '",
      "sudo -s bash -c 'iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l '",
      "sudo -s bash -c 'mkfs.ext4 -F /dev/sdb'",
      "sudo -s bash -c 'mkdir -p ${var.app_bv_mount_path}'",
      "sudo -s bash -c 'mount -t ext4 /dev/sdb ${var.app_bv_mount_path}'",
      "sudo -s bash -c 'echo \"/dev/sdb ${var.app_bv_mount_path} ext4 defaults,noatime,_netdev,nofail 0 2\" >> /etc/fstab'",
    ]
  }
  lifecycle {
    ignore_changes = [instance_id]
  }
}
