############################################
# iam.tf
#
# IAM policy + execution role for MWAA.
#
# Design goals:
# - Portability: no private registry dependencies
# - Least privilege by default (especially S3)
# - Practical guardrails (KMS via service constraints)
# - Optional scoping knobs without breaking existing consumers
############################################

data "aws_iam_policy_document" "policy" {
  ############################################
  # S3 access to the MWAA "source bucket"
  #
  # MWAA needs to:
  # - list the DAG bucket (ListBucket) to discover objects
  # - read objects (GetObject / GetObjectVersion)
  # - sometimes read bucket versioning configuration
  #
  # We intentionally avoid wide permissions like:
  # - s3:List* (can include broader list actions)
  # - s3:GetBucket* (reads ACL/policy/tags unnecessarily)
  ############################################

  statement {
    sid     = "S3ListDagBucket"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      local.s3_bucket_arn
    ]
  }

  statement {
    sid     = "S3GetDagObjects"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = [
      "${local.s3_bucket_arn}/*"
    ]
  }

  statement {
    sid     = "S3GetBucketVersioning"
    effect  = "Allow"
    actions = ["s3:GetBucketVersioning"]
    resources = [
      local.s3_bucket_arn
    ]
  }

  ############################################
  # CloudWatch Logs
  #
  # MWAA creates log groups/streams like:
  #   airflow-<env>-*
  #
  # Include ":*" at the end to cover log-stream ARNs.
  ############################################
  statement {
    sid    = "CloudWatchLogsWrite"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults"
    ]
    resources = [
      "arn:${local.partition}:logs:${data.aws_region.current.region}:${local.account_id}:log-group:airflow-${var.name}-*:*"
    ]
  }

  # Many describe/list APIs are only supported with resource "*"
  #checkov:skip=CKV_AWS_356
  statement {
    sid       = "CloudWatchLogsDescribe"
    effect    = "Allow"
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
  }

  ############################################
  # S3 account public access block check
  #
  # This is called by the AWS SDK / MWAA(Airflow) at runtime
  # as part of bucket access/safety checks. Auditors often flag
  # the wildcard; we keep it with a clear rationale.
  ############################################
  #checkov:skip=CKV_AWS_356
  statement {
    sid       = "S3GetAccountPublicAccessBlock"
    effect    = "Allow"
    actions   = ["s3:GetAccountPublicAccessBlock"]
    resources = ["*"]
  }

  ############################################
  # CloudWatch metrics
  #
  # PutMetricData does not support resource-level permissions.
  ############################################
  statement {
    sid       = "CloudWatchPutMetrics"
    effect    = "Allow"
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }

  ############################################
  # SQS (Celery executor internal queues)
  #
  # Default: account-scoped airflow-celery-*.
  # Optional: allow explicit queue ARNs for stricter scoping.
  ############################################
  statement {
    sid    = "SQSCeleryQueues"
    effect = "Allow"
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    resources = length(coalesce(var.sqs_queue_arns, [])) > 0 ? var.sqs_queue_arns : [
      "arn:${local.partition}:sqs:${data.aws_region.current.region}:*:airflow-celery-*"
    ]
  }

  ############################################
  # KMS (for encrypted S3/SQS with CMK)
  #
  # Important: Avoid NotResource allow statements.
  # Those tend to accidentally grant access to "almost everything".
  #
  # Strategy:
  # - If kms_key_arn is provided, scope to that key.
  # - Otherwise allow "*" (needed for AWS-managed keys) but
  #   constrain by kms:ViaService and encryption context.
  #
  # Practical note: encryption context availability varies.
  # Keep conditions useful but not overly brittle.
  ############################################
  statement {
    sid    = "KMSForS3AndSQS"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt"
    ]
    resources = var.kms_key_arn != null ? [var.kms_key_arn] : ["*"]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "s3.${data.aws_region.current.region}.amazonaws.com",
        "sqs.${data.aws_region.current.region}.amazonaws.com"
      ]
    }

    # Guardrail: only allow KMS usage in the context of this bucket
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values = [
        local.s3_bucket_arn,
        "${local.s3_bucket_arn}/*"
      ]
    }
  }

  ############################################
  # MWAA metrics publication
  ############################################
  statement {
    sid       = "AirflowPublishMetrics"
    effect    = "Allow"
    actions   = ["airflow:PublishMetrics"]
    resources = ["arn:${local.partition}:airflow:${data.aws_region.current.region}:${local.account_id}:environment/${var.name}"]
  }

  ############################################
  # Secrets Manager
  #
  # Backward compatible default: allow reads on "*".
  # Recommended: pass explicit ARNs to scope.
  ############################################
  #checkov:skip=CKV_AWS_356
  statement {
    sid    = "SecretsManagerRead"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = length(coalesce(var.secrets_manager_secret_arns, [])) > 0 ? var.secrets_manager_secret_arns : ["*"]
  }

  # Often unnecessary, kept for backward compatibility.
  #checkov:skip=CKV_AWS_356
  statement {
    sid       = "SecretsManagerList"
    effect    = "Allow"
    actions   = ["secretsmanager:ListSecrets"]
    resources = ["*"]
  }
}

############################################
# IAM role (optional)
#
# Portability fix:
# - remove private registry boundary generator module
# - let the caller provide a permissions boundary ARN directly
############################################
module "iam_role" {
  count   = var.create_iam_role ? 1 : 0
  source  = "schubergphilis-ep/mcaf-role/aws"
  version = "0.5.3"

  name                  = "${var.role_prefix}-MWAA-${var.name}"
  create_policy         = true
  principal_identifiers = ["airflow-env.amazonaws.com", "airflow.amazonaws.com"]
  principal_type        = "Service"
  role_policy           = data.aws_iam_policy_document.combined.json
  tags                  = var.tags

  # Optional permissions boundary (portable)
  permissions_boundary = var.permissions_boundary_arn
}
