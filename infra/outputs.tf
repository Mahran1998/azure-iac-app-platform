output "public_ip" { value = module.network.public_ip }
output "app_url" { value = "http://${module.network.public_ip}" }
output "ssh_command" {
  value = "ssh ${var.admin_username}@${module.network.public_ip}"
}
