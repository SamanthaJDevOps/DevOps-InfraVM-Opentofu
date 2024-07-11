data "template_file" "user_data" {
  template = templatefile(
    "./templates/cloud_init.yml",
    {
        username = var.CLOUDINIT_USER,
        password = bcrypt(var.CLOUDINIT_PASSWORD),
        root_password = var.CLOUDINIT_ROOT_PASSWORD,
        sshpub = local.sshpub
    }
  )
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  pool           = libvirt_pool.cluster.name
}