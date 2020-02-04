# ---------------------------------------------------------------------------------------------------------------------
# GET EXISTING S3 BUCKET
# ---------------------------------------------------------------------------------------------------------------------

data "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN USER WITH A SSH KEY FOR THE SHARED TRANSFER SERVER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_transfer_user" "transfer_user" {
  count          = var.transfer_server_enable_password_auth ? 0 : 1
  server_id      = var.transfer_server_id
  role           = aws_iam_role.transfer_user_assume_role.arn
  home_directory = "/${data.aws_s3_bucket.bucket.id}/${var.s3_bucket_folder}"
  user_name      = var.username
}

resource "aws_transfer_ssh_key" "transfer_ssh_key" {
  count     = var.transfer_server_enable_password_auth ? 0 : var.ssh_public_keys_length
  server_id = var.transfer_server_id
  user_name = var.username
  body      = var.ssh_public_keys[count.index]
}

resource "aws_secretsmanager_secret" "user_secret" {
  count = var.transfer_server_enable_password_auth ? 1 : 0
  name  = "SFTP/${var.username}"
}

resource "random_id" "user_password_random_id" {
  count       = var.transfer_server_enable_password_auth ? 1 : 0
  byte_length = 32
}

resource "aws_secretsmanager_secret_version" "example" {
  count         = var.transfer_server_enable_password_auth ? 1 : 0
  secret_id     = aws_secretsmanager_secret.user_secret[count.index].id
  secret_string = jsonencode(local.user_secret)
}
