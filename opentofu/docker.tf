#resource "docker_image" "mysql-img" {
#  provider = docker
#  name = "mysql:8.0"
#}
#resource "docker_image" "zabbix-proxy-img" {
#  provider = docker
#  name = "zabbix/zabbix-proxy-mysql:latest"
#}
#resource "docker_image" "zabbix-server-img" {
#  provider = docker
#  name = "zabbix/zabbix-server-mysql:latest"
#}
#resource "docker_image" "zabbix-web-img" {
#  provider = docker
#  name = "zabbix/zabbix-web-nginx-mysql:latest"
#}

resource "docker_container" "mysql-server" {
  provider = docker
  name = "z-mysql-server"
#  image = docker_image.mysql-img.name
  image = "mysql:8.0"
  networks_advanced {
    name    = docker_network.zabbix-net.name
    aliases = ["zabbix-net"]
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${var.ZABBIX_SERVER_MYSQL_ROOT_PASSWORD}",
    "MYSQL_DATABASE=${var.ZABBIX_SERVER_MYSQL_DATABASE}",
    "MYSQL_PASSWORD=${var.ZABBIX_SERVER_MYSQL_PASSWORD}",
    "MYSQL_USER=${var.ZABBIX_SERVER_MYSQL_USER}"
  ]
  command = [
    "--character-set-server=utf8",
    "--collation-server=utf8_bin",
    "--log_bin_trust_function_creators=1"
  ]
}

resource "docker_container" "zabbix-server" {
  provider = docker
  name = "z-server"
#  image = docker_image.zabbix-server-img.name
  image = "zabbix/zabbix-server-mysql:latest"
  networks_advanced {
    name    = docker_network.zabbix-net.name
    aliases = ["zabbix-net"]
  }
  ports {
    internal = 10051
    external = var.ZABBIX_SERVER_PORT
    ip       = "0.0.0.0"
  }
  env = [
    "DB_SERVER_HOST=${docker_container.mysql-server.name}",
    "MYSQL_PASSWORD=${var.ZABBIX_SERVER_MYSQL_PASSWORD}",
    "MYSQL_USER=${var.ZABBIX_SERVER_MYSQL_USER}"
  ]
}

resource "docker_container" "zabbix-web" {
  provider = docker
  name = "z-web"
#  image = docker_image.zabbix-web-img.name
  image = "zabbix/zabbix-web-nginx-mysql:latest"
  networks_advanced {
    name    = docker_network.zabbix-net.name
    aliases = ["zabbix-net"]
  }
  ports {
    internal = 80
    external = var.ZABBIX_WEB_PORT
    ip       = "0.0.0.0"
  }
  env = [
    "DB_SERVER_HOST=${docker_container.mysql-server.name}",
    "MYSQL_PASSWORD=${var.ZABBIX_SERVER_MYSQL_PASSWORD}",
    "MYSQL_USER=${var.ZABBIX_SERVER_MYSQL_USER}",
    "ZBX_SERVER_HOST=${docker_container.zabbix-server.name}",
    "PHP_TZ=Europe/Paris"
  ]
}

resource "docker_container" "mysql-proxy" {
  provider = docker
  name = "z-mysql-proxy"
#  image = docker_image.mysql-img.name
  image = "mysql:8.0"
  networks_advanced {
    name    = docker_network.proxy-net.name
    aliases = ["proxy-net"]
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${var.ZABBIX_PROXY_MYSQL_ROOT_PASSWORD}",
    "MYSQL_DATABASE=${var.ZABBIX_PROXY_MYSQL_DATABASE}",
    "MYSQL_PASSWORD=${var.ZABBIX_PROXY_MYSQL_PASSWORD}",
    "MYSQL_USER=${var.ZABBIX_PROXY_MYSQL_USER}"
  ]
  command = [
    "--character-set-server=utf8",
    "--collation-server=utf8_bin",
    "--log_bin_trust_function_creators=1"
  ]
}

resource "docker_container" "zabbix-proxy" {
  provider = docker
  name = "z-proxy"
#  image = docker_image.zabbix-proxy-img.name
  image = "zabbix/zabbix-proxy-mysql:latest"
  networks_advanced {
    # proxy belongs to monitorning network (Zabbix server, etc.)
    name    = docker_network.zabbix-net.name
    aliases = ["zabbix-net"]
  }
  networks_advanced {
    # proxy belongs to CMS network
    name    = docker_network.kvm-net.name
    aliases = ["kvm-net"]
  }
  networks_advanced {
    # proxy belongs to its own network (proxy DB access)
    name    = docker_network.proxy-net.name
    aliases = ["proxy-net"]
  }
  depends_on = [ docker_container.zabbix-server, docker_container.mysql-proxy ]
  ports {
    internal = var.ZABBIX_PROXY_PORT
    external = 10050
    ip       = "0.0.0.0"
  }
  env = [
    "DB_SERVER_HOST=${docker_container.mysql-proxy.name}",
    "MYSQL_PASSWORD=${var.ZABBIX_PROXY_MYSQL_PASSWORD}",
    "MYSQL_USER=${var.ZABBIX_PROXY_MYSQL_USER}",
    "ZBX_PROXYMODE=0", # Active mode
    "ZBX_SERVER_HOST=${docker_container.zabbix-server.network_data[0].ip_address}:${var.ZABBIX_SERVER_PORT}",
    "ZBX_HOSTNAME=${var.ZABBIX_PROXY_HOSTNAME}"

  ]
}
