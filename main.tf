/**
 * # AWS EKS Loki Terraform module
 *
 * A Terraform module to deploy the [Grafana Loki](https://grafana.com/docs/loki/latest/) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-loki/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-loki/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-loki/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-loki/actions/workflows/pre-commit.yml)
 */
locals {
  addon = {
    name = "loki"

    helm_chart_name    = "loki"
    helm_chart_version = "6.25.1" # 3.3.2
    helm_repo_url      = "https://grafana.github.io/helm-charts"
  }

  addon_irsa = {
    (local.addon.name) = {
      irsa_policy_enabled = local.irsa_policy_enabled
      irsa_policy         = var.irsa_policy != null ? var.irsa_policy : try(data.aws_iam_policy_document.this[0].json, "")
    }
  }

  addon_values = yamlencode({
    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
  })
}
