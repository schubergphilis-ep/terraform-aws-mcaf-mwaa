data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition

  # Execution role: created by this module or provided by the caller
  execution_role_arn = var.create_iam_role ? module.iam_role[0].arn : var.execution_role_arn

  # Backward compatible input name: var.policy is "extra role policy JSON"
  additional_role_policy_json = var.policy != null ? var.policy : null

  # Source bucket: created by this module or provided by the caller
  s3_bucket_arn = var.create_s3_bucket ? module.s3_bucket[0].arn : var.source_bucket_arn

  # Null-safe defaulting for optional paths (prevents length(null) crashes)
  plugins_s3_path        = (var.plugins_s3_path != null && length(var.plugins_s3_path) > 0) ? var.plugins_s3_path : "plugins.zip"
  requirements_s3_path   = (var.requirements_s3_path != null && length(var.requirements_s3_path) > 0) ? var.requirements_s3_path : "requirements.txt"
  startup_script_s3_path = (var.startup_script_s3_path != null && length(var.startup_script_s3_path) > 0) ? var.startup_script_s3_path : "startup.sh"

  # Security groups: created by module + any additional SGs
  security_group_ids = var.create_security_group ? concat(var.associated_security_group_ids, aws_security_group.mwaa[*].id) : var.associated_security_group_ids

  # schedulers:
  # Airflow 1.10.12 is EOL on MWAA for new environments, so we only enforce v2+ constraints.
  schedulers_min = 2
  schedulers_max = 5

  # webservers: AWS has special behavior for mw1.micro; keep validation user-friendly.
  webservers_min = var.environment_class == "mw1.micro" ? 1 : 2
  webservers_max = 5
}

############################################
# Merge default policy with optional user-supplied JSON policy
############################################
data "aws_iam_policy_document" "combined" {
  source_policy_documents = compact([
    local.additional_role_policy_json,
    data.aws_iam_policy_document.policy.json
  ])
}

############################################
# Optional: create the MWAA source bucket
############################################
module "s3_bucket" {
  #checkov:skip=CKV_AWS_21
  count   = var.create_s3_bucket ? 1 : 0
  source  = "schubergphilis/mcaf-s3/aws"
  version = "3.0.0"

  name           = "${var.name}-mwaa"
  versioning     = true
  tags           = var.tags
  kms_key_arn    = var.kms_key_arn
  policy         = var.dag_bucket_policy
  logging        = var.s3_logging
  lifecycle_rule = var.s3_lifecycle_rule
}

############################################
# MWAA environment
############################################
resource "aws_mwaa_environment" "default" {
  #checkov:skip=CKV_AWS_243
  #checkov:skip=CKV_AWS_242
  #checkov:skip=CKV_AWS_244

  name                          = var.name
  airflow_configuration_options = var.airflow_configuration_options
  airflow_version               = var.airflow_version

  # Core references
  source_bucket_arn  = local.s3_bucket_arn
  execution_role_arn = local.execution_role_arn

  # General configuration
  dag_s3_path                     = var.dag_s3_path
  environment_class               = var.environment_class
  endpoint_management             = var.endpoint_management
  kms_key                         = var.kms_key_arn
  webserver_access_mode           = var.webserver_access_mode
  weekly_maintenance_window_start = var.weekly_maintenance_window_start

  # Worker scaling
  min_workers = var.min_workers
  max_workers = var.max_workers

  # Newer MWAA knobs
  schedulers                  = var.schedulers
  min_webservers              = var.min_webservers
  max_webservers              = var.max_webservers
  worker_replacement_strategy = var.worker_replacement_strategy

  # Optional S3 artifacts
  plugins_s3_path                  = local.plugins_s3_path
  plugins_s3_object_version        = var.plugins_s3_object_version
  requirements_s3_path             = local.requirements_s3_path
  requirements_s3_object_version   = var.requirements_s3_object_version
  startup_script_s3_path           = local.startup_script_s3_path
  startup_script_s3_object_version = var.startup_script_s3_path_version

  ############################################
  # Logs
  ############################################
  logging_configuration {
    dag_processing_logs {
      enabled   = var.dag_processing_logs_enabled
      log_level = var.dag_processing_logs_level
    }
    scheduler_logs {
      enabled   = var.scheduler_logs_enabled
      log_level = var.scheduler_logs_level
    }
    task_logs {
      enabled   = var.task_logs_enabled
      log_level = var.task_logs_level
    }
    webserver_logs {
      enabled   = var.webserver_logs_enabled
      log_level = var.webserver_logs_level
    }
    worker_logs {
      enabled   = var.worker_logs_enabled
      log_level = var.worker_logs_level
    }
  }

  ############################################
  # Networking
  #
  # MWAA currently expects exactly two subnets.
  # Do not slice or silently ignore user input: validate length == 2.
  ############################################
  network_configuration {
    security_group_ids = local.security_group_ids
    subnet_ids         = var.subnet_ids
  }

  ############################################
  # Cross-variable validations (best place)
  ############################################
  lifecycle {
    precondition {
      condition     = length(var.subnet_ids) == 2
      error_message = "subnet_ids must contain exactly two subnet IDs (MWAA currently requires exactly two subnets)."
    }

    precondition {
      condition     = var.create_s3_bucket || (var.source_bucket_arn != null && length(var.source_bucket_arn) > 0)
      error_message = "When create_s3_bucket=false, source_bucket_arn must be provided."
    }

    precondition {
      condition     = var.create_iam_role || (var.execution_role_arn != null && length(var.execution_role_arn) > 0)
      error_message = "When create_iam_role=false, execution_role_arn must be provided."
    }

    precondition {
      condition = (
        var.schedulers == null ||
        (var.schedulers >= local.schedulers_min && var.schedulers <= local.schedulers_max)
      )
      error_message = "Invalid schedulers: must be between 2 and 5 (or null to use AWS default)."
    }

    precondition {
      condition = (
        (var.min_webservers == null && var.max_webservers == null) ||
        (
          var.min_webservers != null && var.max_webservers != null &&
          var.min_webservers >= local.webservers_min && var.min_webservers <= local.webservers_max &&
          var.max_webservers >= local.webservers_min && var.max_webservers <= local.webservers_max &&
          var.min_webservers <= var.max_webservers
        )
      )
      error_message = "min_webservers and max_webservers must be set together, be within allowed range, and min_webservers <= max_webservers."
    }
  }

  tags = var.tags
}
