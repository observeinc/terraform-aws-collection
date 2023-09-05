terraform {
  required_version = ">= 0.13"
}

locals {
  organization = "observeinc"
  repository   = "terraform-aws-collection"
}

data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  oidc_claim_prefix = trimprefix(data.aws_iam_openid_connect_provider.github_actions.url, "https://")
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringLike"
      variable = "${local.oidc_claim_prefix}:sub"
      values   = ["repo:${local.organization}/${local.repository}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_claim_prefix}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_actions_release" {
  name = "${local.repository}-gha-release"

  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Principal  = "GitHub Actions"
    Repository = "${local.organization}/${local.repository}"
  }
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  role       = aws_iam_role.github_actions_release.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "github_actions_secret" "aws_release_role" {
  repository      = local.repository
  secret_name     = "AWS_ROLE_ARN"
  plaintext_value = aws_iam_role.github_actions_release.arn
}
