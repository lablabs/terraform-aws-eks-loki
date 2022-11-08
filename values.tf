locals {
  values_default = yamlencode({
  })

  helm_values_sa_enabled = yamlencode({
    "serviceAccount" : {
      "name" : "${var.service_account_name}"
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
    local.values_default,
    var.service_account_create ? local.helm_values_sa_enabled : "",
    var.values
  ])
}
