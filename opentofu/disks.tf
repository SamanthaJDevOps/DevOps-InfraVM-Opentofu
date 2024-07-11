resource "libvirt_pool" "cluster" {
  name = var.POOL_NAME
  type = "dir"
  path = var.DISK_STORAGE_PATH
}

resource "libvirt_volume" "ubuntu-base" {
  name = "ubuntu-base"
  pool = libvirt_pool.cluster.name
  source = var.UBUNTU_IMAGE_PATH
  format = "qcow2"
}

resource "libvirt_volume" "campus-ubuntu-disk" {
  name = "campus-ubuntu-disk"
  base_volume_id  = libvirt_volume.ubuntu-base.id
  size = 20737418240
  pool = libvirt_pool.cluster.name
}

resource "libvirt_volume" "rocky-base" {
  name = "rocky-base"
  pool = libvirt_pool.cluster.name
  source = var.ROCKY_IMAGE_PATH
  format = "qcow2"
}

resource "libvirt_volume" "campus-rocky-disk" {
  name = "campus-rocky-disk"
  base_volume_id  = libvirt_volume.rocky-base.id
  size = 32737418240
  pool = libvirt_pool.cluster.name
}
