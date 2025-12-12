

data "aws_iam_policy_document" "policy" {
  #checkov:skip=CKV_AWS_108
  #checkov:skip=CKV_AWS_356
  statement {
    actions = ["s3:ListAllMyBuckets"]
    effect  = "Deny"
    resources = [
      local.s3_bucket_arn,
      "${local.s3_bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    effect = "Allow"
    resources = [
      local.s3_bucket_arn,
    "${local.s3_bucket_arn}/*"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults"
    ]
    effect    = "Allow"
    resources = ["arn:${local.partition}:logs:${data.aws_region.current.region}:${local.account_id}:log-group:airflow-${var.name}-*"]
  }

  #checkov:skip=CKV_AWS_356
  statement {
    actions   = ["logs:DescribeLogGroups"]
    effect    = "Allow"
    resources = ["*"]
  }

  #checkov:skip=CKV_AWS_356
  statement {
    actions   = ["s3:GetAccountPublicAccessBlock"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions   = ["cloudwatch:PutMetricData"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = ["arn:${local.partition}:sqs:${data.aws_region.current.region}:*:airflow-celery-*"]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt"
    ]
    effect        = "Allow"
    not_resources = ["arn:${local.partition}:kms:*:${local.account_id}:key/*"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "sqs.${data.aws_region.current.region}.amazonaws.com",
        "s3.${data.aws_region.current.region}.amazonaws.com"
      ]
    }
  }

  statement {
    actions   = ["airflow:PublishMetrics"]
    effect    = "Allow"
    resources = ["arn:${local.partition}:airflow:${data.aws_region.current.region}:${local.account_id}:environment/${var.name}"]
  }

  #checkov:skip=CKV_AWS_356
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }

}

module "combined_boundary_policy" {
  source            = "app.terraform.io/devolksbank-ep/buildingblock-ep-boundary-policy-gen/aws"
  version           = "~> 0.4.0"
  policy_jsons_list = [data.aws_iam_policy_document.combined.json]
}

module "iam_role" {
  count   = var.create_iam_role ? 1 : 0
  source  = "schubergphilis/mcaf-role/aws"
  version = "0.5.3"

  name                  = join("-", [var.role_prefix, "MWAA", var.name])
  create_policy         = true
  principal_identifiers = ["airflow-env.amazonaws.com", "airflow.amazonaws.com"]
  principal_type        = "Service"
  role_policy           = data.aws_iam_policy_document.combined.json
  tags                  = var.tags
  permissions_boundary  = module.combined_boundary_policy.arn
}
