locals {
  values_default_sa_enabled = yamlencode({
    "serviceAccount" : {
      "name" : "${var.service_account_name}"
      "annotations" : {
        "eks.amazonaws.com/role-arn" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.this.0.name}"
      }
    }

  })
  helm_values_servicemonitor_enabled = yamlencode({
    "serviceMonitor" : {
      "enabled" : true
    }
  })
}

data "aws_caller_identity" "current" {}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values_default,
    var.service_account_create ? local.helm_values_sa_enabled : "",
    var.servicemonitor_enabled ? local.helm_values_servicemonitor_enabled : "",
    var.values
  ])
}
