variable "username" {
  type        = string
  description = "Name of the user that will be created in shared sftp."
}

variable "ssh_public_keys" {
  type        = list(string)
  default     = []
  description = "List of raw SSH public keys."
}

variable "ssh_public_keys_length" {
  default = 0
}

variable "transfer_server_id" {
  type        = string
  description = "ID of the transfer server to use."
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the AWS S3 Bucket where sftp user should have access to."
}

variable "s3_bucket_folder" {
  type        = string
  default     = ""
  description = "If provided, user will have access only to given folder instead of entire bucket."
}

variable "access_type" {
  type        = string
  description = "Which permissions user should have on sftp"
}

variable "iam_name" {
   type = string
   default     = ""
}

variable "policy_name" {
    type = string
}

variable "transfer_server_enable_password_auth" {
  description = "Boolean for whether this transfer server uses password auth"
  default     = false
}
