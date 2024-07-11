resource "null_resource" "zabbix-setup" {
  depends_on = [ libvirt_domain.campus-rocky9, libvirt_domain.campus-ubuntu24, docker_container.zabbix-web, docker_container.zabbix-server, docker_container.zabbix-proxy ]
  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook ./ansiblezabbix/playbook.yml --extra-vars '${jsonencode({
        server_web_ip = docker_container.zabbix-web.network_data[0].ip_address,
        server_web_port = var.ZABBIX_WEB_PORT,
        proxy_hostname = var.ZABBIX_PROXY_HOSTNAME,
        proxy_address = [for net in docker_container.zabbix-proxy.network_data: net.ip_address if net.network_name == "zabbix-net"][0],
        ubuntu_agent_hostname = var.UBUNTU_ZABBIX_AGENT_HOSTNAME,
        ubuntu_ip = libvirt_domain.campus-ubuntu24.network_interface.0.addresses.0,
        rocky_agent_hostname = var.ROCKY_ZABBIX_AGENT_HOSTNAME,
        rocky_ip = libvirt_domain.campus-rocky9.network_interface.0.addresses.0
    })}'
    EOT
  }
}