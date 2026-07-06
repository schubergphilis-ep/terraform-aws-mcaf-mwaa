############################################
# Core
############################################

variable "name" {
  description = "Name of the MWAA environment."
  type        = string

  # Conservative constraint to keep log group ARN construction predictable.
  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-]{0,78}[A-Za-z0-9]$", var.name))
    error_message = "name must be 2-80 chars, alphanumeric with hyphens, and start/end with alphanumeric."
  }
}

variable "vpc_id" {
  description = "VPC ID where the MWAA environment will be deployed."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the MWAA environment. MWAA currently requires exactly two subnets."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}

############################################
# Resource creation toggles
############################################

variable "create_s3_bucket" {
  description = "Whether to create an S3 bucket for MWAA DAGs/plugins/requirements/startup scripts."
  type        = bool
  default     = true
}

variable "create_iam_role" {
  description = "Whether to create the MWAA execution IAM role."
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "Whether to create a security group for MWAA."
  type        = bool
  default     = true
}

############################################
# IAM: role settings & scoping knobs
############################################

variable "role_prefix" {
  description = "Prefix used when naming the created IAM role."
  type        = string
  default     = "app"
}

variable "execution_role_arn" {
  description = "If `create_iam_role` is false, ARN of the existing MWAA execution role."
  type        = string
  default     = ""
}

variable "permissions_boundary_arn" {
  description = "ARN of the permissions boundary to apply to the created MWAA execution role. If null, no boundary is applied."
  type        = string
  default     = null
}

variable "policy" {
  description = "Additional IAM policy JSON to merge into the MWAA execution role policy (not an S3 bucket policy)."
  type        = string
  default     = null
}

variable "secrets_manager_secret_arns" {
  description = "List of Secrets Manager secret ARNs the MWAA role may read. If empty, access defaults to '*'."
  type        = list(string)
  default     = []
}

variable "sqs_queue_arns" {
  description = "Explicit list of SQS queue ARNs used by the MWAA role. If empty, defaults to account-scoped airflow-celery-*."
  type        = list(string)
  default     = []
}

############################################
# Networking
############################################

variable "associated_security_group_ids" {
  description = <<-EOT
    A list of security group IDs to associate with the MWAA environment, in addition to the security group created by this module.
    These security groups are not modified. If `create_security_group` is false, the provided security groups must include the desired rules.
  EOT
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "IPv4 CIDR blocks allowed to reach the created security group on port 443."
  type        = list(string)
  default     = []
}

variable "security_group_egress_cidr_blocks" {
  description = "CIDR blocks allowed for egress from the created security group. Default is open egress (often required for package installs)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

############################################
# MWAA environment configuration
############################################

variable "airflow_version" {
  description = "Airflow version for the MWAA environment."
  type        = string
}

variable "airflow_configuration_options" {
  description = "Airflow configuration override options for the environment."
  type        = any
  default     = null
}

variable "dag_s3_path" {
  description = "Relative path to the DAGs folder within the source bucket."
  type        = string
  default     = "dags"
}

variable "environment_class" {
  description = "Environment class for MWAA (e.g. mw1.small, mw1.medium, mw1.large, mw1.micro)."
  type        = string
  default     = "mw1.small"
}

variable "endpoint_management" {
  description = "Whether MWAA manages the endpoint (SERVICE) or the customer manages it (CUSTOMER)."
  type        = string
  default     = "SERVICE"
  validation {
    condition     = contains(["SERVICE", "CUSTOMER"], var.endpoint_management)
    error_message = "endpoint_management must be SERVICE or CUSTOMER."
  }
}

variable "webserver_access_mode" {
  description = "Webserver accessibility mode. Valid values: PRIVATE_ONLY (default) or PUBLIC_ONLY."
  type        = string
  default     = "PRIVATE_ONLY"
  validation {
    condition     = contains(["PRIVATE_ONLY", "PUBLIC_ONLY"], var.webserver_access_mode)
    error_message = "webserver_access_mode must be PRIVATE_ONLY or PUBLIC_ONLY."
  }
}

variable "weekly_maintenance_window_start" {
  description = "Start time for the weekly maintenance window."
  type        = string
  default     = null
}

############################################
# Worker scaling
############################################

variable "min_workers" {
  description = "Minimum number of workers."
  type        = number
  default     = 1
  validation {
    condition     = var.min_workers >= 1 && var.min_workers <= 25
    error_message = "min_workers must be between 1 and 25."
  }
}

variable "max_workers" {
  description = "Maximum number of workers for autoscaling."
  type        = number
  default     = 10
  validation {
    condition     = var.max_workers >= 1 && var.max_workers <= 25 && var.max_workers >= var.min_workers
    error_message = "max_workers must be between 1 and 25 and >= min_workers."
  }
}

############################################
# Newer MWAA knobs
############################################

variable "schedulers" {
  description = "Number of Airflow schedulers (Airflow v2+). Valid range: 2-5 (or null to use AWS default)."
  type        = number
  default     = null
}

variable "min_webservers" {
  description = "Minimum number of webservers (typically 2-5; mw1.micro may allow 1)."
  type        = number
  default     = null
}

variable "max_webservers" {
  description = "Maximum number of webservers (typically 2-5; mw1.micro may allow 1)."
  type        = number
  default     = null
}

variable "worker_replacement_strategy" {
  description = "Worker replacement strategy during updates. Valid values: FORCED, GRACEFUL."
  type        = string
  default     = "GRACEFUL"
  validation {
    condition     = var.worker_replacement_strategy == null || contains(["FORCED", "GRACEFUL"], var.worker_replacement_strategy)
    error_message = "worker_replacement_strategy must be one of: FORCED, GRACEFUL."
  }
}

############################################
# S3: bucket selection & paths
############################################

variable "source_bucket_arn" {
  description = "If `create_s3_bucket` is false, ARN of the existing S3 bucket used by MWAA."
  type        = string
  default     = null
}

variable "plugins_s3_path" {
  description = "Relative path to plugins archive (e.g. plugins.zip). If null/empty, defaults to plugins.zip."
  type        = string
  default     = null
}

variable "plugins_s3_object_version" {
  description = "S3 object version for plugins archive (optional)."
  type        = string
  default     = null
}

variable "requirements_s3_path" {
  description = "Relative path to requirements file (e.g. requirements.txt). If null/empty, defaults to requirements.txt."
  type        = string
  default     = null
}

variable "requirements_s3_object_version" {
  description = "S3 object version for requirements file (optional)."
  type        = string
  default     = null
}

variable "startup_script_s3_path" {
  description = "Relative path to startup script (e.g. startup.sh). If null/empty, defaults to startup.sh."
  type        = string
  default     = null
}

variable "startup_script_s3_path_version" {
  description = "S3 object version for startup script (optional)."
  type        = string
  default     = null
}

############################################
# CloudWatch logging configuration (MWAA logs)
############################################

variable "dag_processing_logs_enabled" {
  description = "Enable DAG processing logs."
  type        = bool
  default     = false
}

variable "dag_processing_logs_level" {
  description = "DAG processing log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG."
  type        = string
  default     = "INFO"
}

variable "scheduler_logs_enabled" {
  description = "Enable scheduler logs."
  type        = bool
  default     = false
}

variable "scheduler_logs_level" {
  description = "Scheduler log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG."
  type        = string
  default     = "INFO"
}

variable "task_logs_enabled" {
  description = "Enable task logs."
  type        = bool
  default     = false
}

variable "task_logs_level" {
  description = "Task log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG."
  type        = string
  default     = "INFO"
}

variable "webserver_logs_enabled" {
  description = "Enable webserver logs."
  type        = bool
  default     = false
}

variable "webserver_logs_level" {
  description = "Webserver log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG."
  type        = string
  default     = "INFO"
}

variable "worker_logs_enabled" {
  description = "Enable worker logs."
  type        = bool
  default     = false
}

variable "worker_logs_level" {
  description = "Worker log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG."
  type        = string
  default     = "INFO"
}

############################################
# Encryption (KMS)
############################################

variable "kms_key_arn" {
  description = "KMS key ARN used for encryption (MWAA env and created S3 bucket)."
  type        = string
  default     = null
}

############################################
# S3 bucket: policy, access logging & lifecycle (when create_s3_bucket = true)
############################################

variable "dag_bucket_policy" {
  description = "Bucket policy JSON applied to the MWAA source bucket (when created by this module)."
  type        = string
  default     = null
}

variable "s3_logging" {
  description = "S3 server access logging configuration. Disabled when null."
  type = object({
    target_bucket = string
    target_prefix = string
    target_object_key_format = optional(object({
      format_type           = optional(string)
      partition_date_source = optional(string, "DeliveryTime")
    }))
  })
  default = null

  validation {
    condition = var.s3_logging == null ? true : (
      var.s3_logging.target_object_key_format == null ? true : (
        contains(["simple", "partitioned"], var.s3_logging.target_object_key_format.format_type) &&
        (
          var.s3_logging.target_object_key_format.format_type == "simple" ||
          contains(["DeliveryTime", "EventTime"], var.s3_logging.target_object_key_format.partition_date_source)
        )
      )
    )
    error_message = "Invalid s3_logging configuration."
  }
}

variable "s3_lifecycle_rule" {
  description = "Lifecycle rules for the created S3 bucket."
  type        = any
  default     = []
}

############################################
# CloudWatch Log Groups retention management (optional)
############################################

variable "manage_mwaa_log_group_retention" {
  description = <<-EOT
    If true, the module will ensure MWAA CloudWatch log groups exist and enforce a retention period.
    This works for both new and existing environments: no import is required (Terraform will adopt by name).
  EOT
  type        = bool
  default     = false
}

variable "mwaa_log_retention_in_days" {
  description = "Retention (in days) to apply to MWAA CloudWatch log groups when manage_mwaa_log_group_retention=true."
  type        = number
  default     = 30

  validation {
    condition     = var.mwaa_log_retention_in_days == null || var.mwaa_log_retention_in_days >= 1
    error_message = "mwaa_log_retention_in_days must be >= 1 when set."
  }
}

variable "mwaa_log_group_prevent_destroy" {
  description = "If true, prevent Terraform from destroying MWAA log groups managed for retention."
  type        = bool
  default     = true
}

variable "mwaa_log_group_tags" {
  description = "Additional tags to apply to MWAA log groups (merged with var.tags)."
  type        = map(string)
  default     = {}
}

############################################
# Deprecated / unused variables (kept for BC)
############################################

variable "log_bucket" {
  description = "⚠️ Deprecated: no longer used. Use `s3_logging.target_bucket` instead."
  type        = string
  default     = null
}

variable "kms_key" {
  description = "⚠️ Deprecated: use `kms_key_arn`."
  type        = string
  default     = null
}

variable "trusting_accounts" {
  description = "⚠️ Deprecated/unused: has no effect."
  type        = list(string)
  default     = []
}

# Deprecation warnings kept because you asked for them previously.
output "log_bucket_deprecation" {
  value = (var.log_bucket != null
    ? "⚠️ Warning: 'log_bucket' is deprecated and has no effect. Use 's3_logging.target_bucket' instead."
  : "")
}

output "kms_key_deprecation" {
  value = (var.kms_key != null
    ? "⚠️ Warning: 'kms_key' is deprecated. Use 'kms_key_arn' instead."
  : "")
}

output "trusting_accounts_deprecation" {
  value = (length(var.trusting_accounts) > 0
    ? "⚠️ Warning: 'trusting_accounts' is deprecated/unused and has no effect."
  : "")
}
