terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "libvirt" {
  uri = "qemu:///system"
}
