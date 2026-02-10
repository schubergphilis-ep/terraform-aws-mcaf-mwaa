variable "name" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "create_s3_bucket" {
  type        = bool
  description = "Enabling or disabling the creatation of an S3 bucket for AWS MWAA"
  default     = true
}

variable "create_iam_role" {
  type        = bool
  description = "Enabling or disabling the creatation of a default IAM Role for AWS MWAA"
  default     = true
}

variable "create_security_group" {
  type        = bool
  description = "Enabling or disabling the creatation of a default SecurityGroup for AWS MWAA"
  default     = true
}

variable "log_bucket" {
  type    = string
  default = null
}

variable "source_bucket_arn" {
  type        = string
  description = "If `create_s3_bucket` is `false` then set this to the Amazon Resource Name (ARN) of your Amazon S3 storage bucket."
  default     = null
}

variable "execution_role_arn" {
  type        = string
  default     = ""
  description = "If `create_iam_role` is `false` then set this to the target MWAA execution role"
}

variable "airflow_configuration_options" {
  description = "The Airflow override options"
  type        = any
  default     = null
}

variable "airflow_version" {
  type        = string
  description = "Airflow version of the MWAA environment."
}

variable "dag_s3_path" {
  type        = string
  description = "The relative path to the DAG folder on your Amazon S3 storage bucket."
  default     = "dags"
}

variable "environment_class" {
  type        = string
  description = "Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large."
  default     = "mw1.small"
}

variable "kms_key" {
  type        = string
  description = "The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption. Will be set to the ARN of the managed KMS key aws/airflow by default."
  default     = null
}

variable "max_workers" {
  type        = number
  description = "The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25."
  default     = 10
}

variable "min_workers" {
  type        = number
  description = "The minimum number of workers that you want to run in your environment."
  default     = 1
}

variable "plugins_s3_object_version" {
  type        = string
  description = "The plugins.zip file version you want to use."
  default     = null
}

variable "plugins_s3_path" {
  type        = string
  description = "The relative path to the plugins.zip file on your Amazon S3 storage bucket. For example, plugins.zip. If a relative path is provided in the request, then plugins_s3_object_version is required"
  default     = null
}

variable "requirements_s3_object_version" {
  type        = string
  description = "The requirements.txt file version you want to use."
  default     = null
}

variable "requirements_s3_path" {
  type        = string
  description = "The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. If a relative path is provided in the request, then requirements_s3_object_version is required"
  default     = null
}

variable "webserver_access_mode" {
  type        = string
  description = "Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE_ONLY (default) and PUBLIC_ONLY."
  default     = "PRIVATE_ONLY"
}

variable "weekly_maintenance_window_start" {
  type        = string
  description = "Specifies the start date for the weekly maintenance window."
  default     = null
}

variable "dag_processing_logs_enabled" {
  type        = bool
  description = "Enabling or disabling the collection of logs for processing DAGs"
  default     = false
}

variable "dag_processing_logs_level" {
  type        = string
  description = "DAG processing logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG"
  default     = "INFO"
}

variable "policy" {
  type        = string
  default     = null
  description = "A valid bucket policy JSON document"
}

variable "scheduler_logs_enabled" {
  type        = bool
  description = "Enabling or disabling the collection of logs for the schedulers"
  default     = false
}

variable "scheduler_logs_level" {
  type        = string
  description = "Schedulers logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG"
  default     = "INFO"
}

variable "task_logs_enabled" {
  type        = bool
  description = "Enabling or disabling the collection of logs for DAG tasks"
  default     = false
}

variable "task_logs_level" {
  type        = string
  description = "DAG tasks logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG"
  default     = "INFO"
}

variable "webserver_logs_enabled" {
  type        = bool
  description = "Enabling or disabling the collection of logs for the webservers"
  default     = false
}

variable "webserver_logs_level" {
  type        = string
  description = "Webserver logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG"
  default     = "INFO"
}

variable "worker_logs_enabled" {
  type        = bool
  description = "Enabling or disabling the collection of logs for the workers"
  default     = false
}

variable "worker_logs_level" {
  type        = string
  description = "Workers logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG"
  default     = "INFO"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The private subnet IDs in which the environment should be created. MWAA requires two subnets"
}

variable "associated_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.
    These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access.
    EOT
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv4 CIDRs to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "trusting_accounts" {
  type        = list(string)
  default     = []
  description = "Account IDs that will trust this MWAA cluster to assume roles."
}

variable "startup_script_s3_path" {
  type        = string
  default     = null
  description = "The relative path to the startup script on your Amazon S3 storage bucket. For example, startup.sh"
}

variable "startup_script_s3_path_version" {
  type        = string
  default     = null
  description = "The version of the startup script on your Amazon S3 storage bucket."
}

# tflint-ignore: terraform_unused_declarations
variable "permissions_boundary" {
  type        = string
  description = "Will be deprecated in future version"
  default     = null
}

output "permissions_boundary_deprecation" {
  value = var.permissions_boundary != null ? "⚠️ Warning: The 'permissions_boundary' variable is deprecated and will be removed in a future version." : ""
}

variable "role_prefix" {
  type        = string
  default     = "app"
  description = "Prefix for the IAM role"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The ARN of the KMS key to use for encryption"
}

variable "endpoint_management" {
  type        = string
  default     = "SERVICE"
  description = "Let MWAA manage the endpoint or not. Possible values: SERVICE, CUSTOMER"
  validation {
    condition     = var.endpoint_management == "SERVICE" || var.endpoint_management == "CUSTOMER"
    error_message = "endpoint_management can be SERVICE or CUSTOMER"
  }
}

variable "s3_logging" {
  type = object({
    target_bucket = string
    target_prefix = string
    target_object_key_format = optional(object({
      format_type           = optional(string)                 # "simple" or "partitioned"
      partition_date_source = optional(string, "DeliveryTime") # Required if format_type is "partitioned", default is DeliveryTime
    }))
  })

  default     = null
  description = "Logging configuration, logging is disabled by default."

  validation {
    condition = var.s3_logging == null ? true : (
      # target_object_key_format should be null or have a valid format_type
      var.s3_logging.target_object_key_format == null ? true : (
        # target_object_key_format.format_type must be "simple" or "partitioned"
        contains(["simple", "partitioned"], var.s3_logging.target_object_key_format.format_type) &&
        (
          # If simple, partition_date_source doesn't matter
          var.s3_logging.target_object_key_format.format_type == "simple" ||
          (
            # If partitioned, partition_date_source must be "DeliveryTime" or "EventTime"
            var.s3_logging.target_object_key_format.format_type == "partitioned" &&
            contains(["DeliveryTime", "EventTime"], var.s3_logging.target_object_key_format.partition_date_source)
          )
        )
      )
    )
    error_message = "When logging is enabled: target_object_key_format.format_type must be 'simple' or 'partitioned'. If set to partitioned, target_object_key_format.partition_date_source must be 'DeliveryTime' or 'EventTime'."
  }
}

variable "s3_lifecycle_rule" {
  type        = any
  default     = []
  description = "List of maps containing lifecycle management configuration settings."
}

variable "dag_bucket_policy" {
  type        = string
  default     = null
  description = "A valid dag bucket policy JSON document"
}

variable "schedulers" {
  description = "Number of Airflow schedulers (Airflow v2+). Valid range: 2-5 (or null to use AWS default)."
  type        = number
  default     = null
}