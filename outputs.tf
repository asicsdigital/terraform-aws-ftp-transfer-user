output "user_password" {
  value     = local.user_secret["Password"]
  sensitive = true
}
