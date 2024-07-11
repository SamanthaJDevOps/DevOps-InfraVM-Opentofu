# Output example
output "ip" {
  value = libvirt_domain.campus-ubuntu24.network_interface.0.addresses
}
