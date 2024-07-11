resource "libvirt_domain" "campus-rocky9" {
  name   = "rocky-campus"
  memory = "4096"
  vcpu   = 2
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  depends_on = [ docker_container.zabbix-proxy ]

  cpu {
    mode = "host-passthrough"
  }
  disk {
    volume_id = libvirt_volume.campus-rocky-disk.id
  }

  network_interface {
    network_name = "infra-net"
    wait_for_lease = true
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_SHELL_ALLOW_WORLD_READABLE_TEMP=True ANSIBLE_PIPELINING=True ansible-playbook -u ${var.CLOUDINIT_USER} -i ${self.network_interface.0.addresses.0}, --private-key ${var.CLOUDINIT_SSH_PRIVATE_KEY_PATH} ./ansiblerocky/playbook.yml --extra-vars 'address=${self.network_interface.0.addresses.0}' --extra-vars '${jsonencode({
        wp_admin_user = var.CLOUDINIT_USER,
        wp_admin_password = var.CLOUDINIT_PASSWORD,
        zabbix_agent_hostname = var.UBUNTU_ZABBIX_AGENT_HOSTNAME,
        zabbix_proxy_ip = [for net in docker_container.zabbix-proxy.network_data: net.ip_address if net.network_name == "kvm-net"][0],
        zabbix_proxy_port = var.ZABBIX_PROXY_PORT,
        web_user = var.CLOUDINIT_USER,
        wp_site_title = var.ROCKY_WP_TITLE,
        wp_admin_email = var.ROCKY_WP_EMAIL,
        db_name = var.ROCKY_WP_MYSQL_DATABASE,
        db_user_name = var.ROCKY_WP_MYSQL_USER,
        db_root_password = var.ROCKY_WP_MYSQL_ROOT_PASSWORD,
        db_user_password = var.ROCKY_WP_MYSQL_PASSWORD,
        php_version = var.PHP_VERSION
    })}'
    EOT
  }
}