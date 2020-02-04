locals {
  s3_actions = {
    "rw" = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
    "ro" = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
  }
  user_secret = {
    Password      = var.transfer_server_enable_password_auth ? random_id.user_password_random_id[0].b64 : ""
    Role          = aws_iam_role.transfer_user_assume_role.arn
    HomeDirectory = "/${var.s3_bucket_name}/${var.s3_bucket_folder}${var.s3_bucket_folder == "" ? "" : "/"}"
    PublicKey     = var.transfer_server_enable_password_auth ? "" : var.ssh_public_keys[0] # TODO add warning if more than one
  }
}
