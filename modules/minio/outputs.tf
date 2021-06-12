output "access_key" {
  value     = random_password.access_key.result
  sensitive = true
}

output "secret_key" {
  value     = random_password.secret_key.result
  sensitive = true
}

output "data_disk_id" {
  value = sakuracloud_disk.data_disk.id
}
