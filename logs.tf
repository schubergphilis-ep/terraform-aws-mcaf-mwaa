############################################
# logs.tf
#
# Optional: manage CloudWatch Log Group retention for MWAA.
#
# Why:
# - MWAA auto-creates its log groups with "Never Expire" retention by default.
# - Pre-creating (or adopting) the log groups by name lets us enforce retention
#   without importing existing environments.
#
# Behavior:
# - If the log group already exists, Terraform will adopt it by name and update retention. No need to import such resources.
# - If it does not exist yet (e.g., logging disabled or environment not created), Terraform will create it.
############################################

locals {
  # MWAA log group suffixes (AWS convention)
  # Only manage those where logging is enabled, to avoid creating unused log groups.
  mwaa_log_groups_enabled = {
    DagProcessing = var.dag_processing_logs_enabled
    Scheduler     = var.scheduler_logs_enabled
    Task          = var.task_logs_enabled
    WebServer     = var.webserver_logs_enabled
    Worker        = var.worker_logs_enabled
  }

  mwaa_log_groups_to_manage = coalesce(var.manage_mwaa_log_group_retention, false) ? {
    for k, enabled in local.mwaa_log_groups_enabled : k => enabled if enabled
  } : {}

  mwaa_log_group_tags_merged = merge(var.tags, var.mwaa_log_group_tags)
}

# -------------------------------
# Variant A: prevent_destroy = true
# -------------------------------
resource "aws_cloudwatch_log_group" "mwaa_protected" {
  for_each = var.mwaa_log_group_prevent_destroy ? local.mwaa_log_groups_to_manage : {}

  # MWAA log group naming pattern
  name              = "airflow-${var.name}-${each.key}"
  retention_in_days = var.mwaa_log_retention_in_days

  lifecycle {
    prevent_destroy = true
  }

  tags = local.mwaa_log_group_tags_merged
}

# -------------------------------
# Variant B: prevent_destroy = false
# -------------------------------
resource "aws_cloudwatch_log_group" "mwaa_unprotected" {
  for_each = var.mwaa_log_group_prevent_destroy ? {} : local.mwaa_log_groups_to_manage

  # MWAA log group naming pattern
  name              = "airflow-${var.name}-${each.key}"
  retention_in_days = var.mwaa_log_retention_in_days

  lifecycle {
    prevent_destroy = false
  }

  tags = local.mwaa_log_group_tags_merged
}
