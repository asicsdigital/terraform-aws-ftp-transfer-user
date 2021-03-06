# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM POLICY RULES FOR SFTP BUCKET
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "transfer_user_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "transfer_user_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      data.aws_s3_bucket.bucket.arn,
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        var.s3_bucket_folder == "" ? "*" : "${var.s3_bucket_folder}/*",
      ]
    }
  }

  statement {
    effect = "Allow"

    actions = local.s3_actions[var.access_type]

    resources = [
      var.s3_bucket_folder == "" ? "${data.aws_s3_bucket.bucket.arn}/*" : "${data.aws_s3_bucket.bucket.arn}/${var.s3_bucket_folder}/*",
      var.s3_bucket_folder == "" ? data.aws_s3_bucket.bucket.arn : "${data.aws_s3_bucket.bucket.arn}/${var.s3_bucket_folder}",
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM POLICY AND ROLE FROM DEFINED RULES
# ---------------------------------------------------------------------------------------------------------------------

# resource "random_string" "iam_id" {
#   length  = 8
#   special = false
# }

resource "aws_iam_role" "transfer_user_assume_role" {
  name               = "${var.iam_name}-user-role"
  assume_role_policy = data.aws_iam_policy_document.transfer_user_assume_role.json
}

resource "aws_iam_role_policy" "transfer_user_policy" {
  name   = "${var.iam_name}-user-policy"
  role   = aws_iam_role.transfer_user_assume_role.name
  policy = data.aws_iam_policy_document.transfer_user_assume_policy.json
}
