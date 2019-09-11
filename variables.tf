variable "username" {
  description = "Name of the user that will be created in shared sftp."
}

variable "ssh_public_keys" {
  default = []
  description = "List of raw SSH public keys."
}

variable "ssh_public_keys_length" {
}

variable "transfer_server_id" {
  description = "ID of the transfer server to use."
}

variable "s3_bucket_name" {
  description = "Name of the AWS S3 Bucket where sftp user should have access to."
}

variable "s3_bucket_folder" {
  default     = ""
  description = "If provided, user will have access only to given folder instead of entire bucket."
}

variable "access_type" {
  description = "Which permissions user should have on sftp"
}
