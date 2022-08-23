locals {
  values_default_sa_enabled = yamlencode({
    "serviceAccount" : {
      "annotations" : {
        "eks.amazonaws.com/role-arn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.this.0.name}"
      }
    }
  })
}

data "aws_caller_identity" "current" {}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    var.service_account_create ? local.values_default_sa_enabled : "",
    var.values
  ])
}
