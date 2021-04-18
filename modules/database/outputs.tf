output "username" {
  value     = random_password.username.result
  sensitive = true
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}
