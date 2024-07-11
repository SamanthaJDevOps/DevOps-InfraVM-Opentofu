resource "libvirt_network" "infra-net" {
  name      = "infra-net"
  mode      = "nat"
  autostart = "true"
  addresses = [var.LIBVIRT_NETWORK_SUBNET]
  dhcp {
      enabled = true
  }
  dns {
    enabled    = true
    local_only = false
  }
}

resource "docker_network" "kvm-net" {
  provider = docker
  name  = "kvm-net"
  driver = "macvlan"
  
  ipam_config  {
    subnet = var.LIBVIRT_NETWORK_SUBNET
    gateway = var.LIBVIRT_NETWORK_GATEWAY
  }
  options = {
    parent = var.LIBVIRT_NETWORK_BRIDGE_NAME
  }
  depends_on = [ libvirt_network.infra-net ]
}

resource "docker_network" "zabbix-net" {
  provider = docker
  name  = "zabbix-net"
  driver = "bridge"
  
  ipam_config  {
    subnet = var.DOCKER_NETWORK_ZABBIX_SUBNET
    gateway = var.DOCKER_NETWORK_ZABBIX_GATEWAY 
  }
}

resource "docker_network" "proxy-net" {
  provider = docker
  name  = "proxy-net"
  driver = "bridge"
  
  ipam_config  {
    subnet = var.DOCKER_NETWORK_PROXY_SUBNET
    gateway = var.DOCKER_NETWORK_PROXY_GATEWAY
  }
}