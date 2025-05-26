locals {
  irsa_policy_enabled = var.irsa_policy_enabled != null ? var.irsa_policy_enabled : coalesce(var.irsa_assume_role_enabled, false) == false
}

data "aws_iam_policy_document" "this" {
  count = var.enabled && local.irsa_policy_enabled && var.irsa_policy == null ? 1 : 0

  statement {
    sid    = "AllowLokiObjectStore"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:ListObjects",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::loki*"
    ]
  }
}
