output "username" {
  value     = random_password.username.result
  sensitive = true
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

output "data_disk_id" {
  value = sakuracloud_disk.data_disk.id
}
