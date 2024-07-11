variable "CLOUDINIT_USER" {
  type = string
  default = "user"
}

variable "CLOUDINIT_PASSWORD" {
  type = string
  default = "azerty123"
  sensitive = true
}

variable "CLOUDINIT_ROOT_PASSWORD" {
  type = string
  default = "azerty123"
  sensitive = true
}

variable "CLOUDINIT_SSH_PUBLIC_KEY_PATH" {
  type = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "CLOUDINIT_SSH_PRIVATE_KEY_PATH" {
  type = string
  default = "~/.ssh/id_ed25519"
}

locals {
  sshpub = file(var.CLOUDINIT_SSH_PUBLIC_KEY_PATH)
}

variable "ZABBIX_PROXY_PORT" {
  default = "10051"
}

variable "ZABBIX_SERVER_PORT" {
  default = "10051"
}

variable "ZABBIX_PROXY_HOSTNAME" {
  default = "zabbix-proxy-mysql"
}

variable "UBUNTU_ZABBIX_AGENT_HOSTNAME" {
  default = "ubuntu-agent"
}

variable "ROCKY_ZABBIX_AGENT_HOSTNAME" {
  default = "rocky-agent"
}

variable "ZABBIX_WEB_PORT" {
  default = "8080"
}

variable "PHP_VERSION" {
  default = 8.3
}

variable "ZABBIX_PROXY_MYSQL_DATABASE" {
  default = "zabbix_proxy"
}

variable "ZABBIX_PROXY_MYSQL_USER" {
  default = "user"
}

variable "ZABBIX_PROXY_MYSQL_ROOT_PASSWORD" {
  default = "azerty123"
  sensitive = true
}

variable "ZABBIX_PROXY_MYSQL_PASSWORD" {
  default = "azerty123"
  sensitive = true
}

variable "ZABBIX_SERVER_MYSQL_ROOT_PASSWORD" {
  default = "azerty123"
  sensitive = true
}
variable "ZABBIX_SERVER_MYSQL_USER" {
  default = "user"
}

variable "ZABBIX_SERVER_MYSQL_PASSWORD" {
  default = "azerty123"
  sensitive = true
}

variable "ZABBIX_SERVER_MYSQL_DATABASE" {
  default = "zabbix"
}

variable "UBUNTU_WP_TITLE" {
  default = "Mon Super Site"
}

variable "UBUNTU_WP_EMAIL" {
  default = "example@example.com"
}

variable "UBUNTU_WP_MYSQL_DATABASE" {
  default = "wordpress_db"
}

variable "UBUNTU_WP_MYSQL_USER" {
  default = "user"
}

variable "UBUNTU_WP_MYSQL_ROOT_PASSWORD" {
  default = "azerty123"
  sensitive = true
}

variable "UBUNTU_WP_MYSQL_PASSWORD" {
  default = "azerty123"
  sensitive = true
}

variable "ROCKY_WP_TITLE" {
  default = "Mon Super Site"
}

variable "ROCKY_WP_EMAIL" {
  default = "example@example.com"
}

variable "ROCKY_WP_MYSQL_DATABASE" {
  default = "wordpress_db"
}

variable "ROCKY_WP_MYSQL_USER" {
  default = "user"
}

variable "ROCKY_WP_MYSQL_ROOT_PASSWORD" {
  default = "azerty123"
  sensitive = true
}

variable "ROCKY_WP_MYSQL_PASSWORD" {
  default = "azerty123"
  sensitive = true
}

variable "LIBVIRT_NETWORK_SUBNET" {
  default = "192.168.110.0/24"
}

variable "LIBVIRT_NETWORK_GATEWAY" {
  default = "192.168.110.1"
}

variable "LIBVIRT_NETWORK_BRIDGE_NAME" {
  default = "virbr1"
}

variable "DOCKER_NETWORK_PROXY_SUBNET" {
  default = "172.25.10.0/24"
}

variable "DOCKER_NETWORK_PROXY_GATEWAY" {
  default = "172.25.10.1"
}

variable "DOCKER_NETWORK_ZABBIX_SUBNET" {
  default = "172.20.50.0/24"
}

variable "DOCKER_NETWORK_ZABBIX_GATEWAY" {
  default = "172.20.50.1"
}

variable "POOL_NAME" {
  default = "cluster"
}

variable "DISK_STORAGE_PATH" {
  default = "~/disks"
}

variable "UBUNTU_IMAGE_PATH" {
  default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  type = string
}

variable "ROCKY_IMAGE_PATH" {
  default = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base-9.4-20240509.0.x86_64.qcow2"
  type = string
}