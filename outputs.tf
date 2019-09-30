output "user_password" {
  value     = "${random_id.user_password_random_id.b64}"
  sensitive = true
}