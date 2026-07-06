# terraform-aws-mcaf-mwaa

Terraform module to create and manage AWS MWAA environments.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_role"></a> [iam\_role](#module\_iam\_role) | schubergphilis/mcaf-role/aws | 0.5.3 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | schubergphilis/mcaf-s3/aws | 3.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.mwaa_protected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.mwaa_unprotected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_mwaa_environment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment) | resource |
| [aws_security_group.mwaa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airflow_version"></a> [airflow\_version](#input\_airflow\_version) | Airflow version for the MWAA environment. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the MWAA environment. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for the MWAA environment. MWAA currently requires exactly two subnets. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the MWAA environment will be deployed. | `string` | n/a | yes |
| <a name="input_airflow_configuration_options"></a> [airflow\_configuration\_options](#input\_airflow\_configuration\_options) | Airflow configuration override options for the environment. | `any` | `null` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | IPv4 CIDR blocks allowed to reach the created security group on port 443. | `list(string)` | `[]` | no |
| <a name="input_associated_security_group_ids"></a> [associated\_security\_group\_ids](#input\_associated\_security\_group\_ids) | A list of security group IDs to associate with the MWAA environment, in addition to the security group created by this module.<br/>These security groups are not modified. If `create_security_group` is false, the provided security groups must include the desired rules. | `list(string)` | `[]` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether to create the MWAA execution IAM role. | `bool` | `true` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create an S3 bucket for MWAA DAGs/plugins/requirements/startup scripts. | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create a security group for MWAA. | `bool` | `true` | no |
| <a name="input_dag_bucket_policy"></a> [dag\_bucket\_policy](#input\_dag\_bucket\_policy) | Bucket policy JSON applied to the MWAA source bucket (when created by this module). | `string` | `null` | no |
| <a name="input_dag_processing_logs_enabled"></a> [dag\_processing\_logs\_enabled](#input\_dag\_processing\_logs\_enabled) | Enable DAG processing logs. | `bool` | `false` | no |
| <a name="input_dag_processing_logs_level"></a> [dag\_processing\_logs\_level](#input\_dag\_processing\_logs\_level) | DAG processing log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG. | `string` | `"INFO"` | no |
| <a name="input_dag_s3_path"></a> [dag\_s3\_path](#input\_dag\_s3\_path) | Relative path to the DAGs folder within the source bucket. | `string` | `"dags"` | no |
| <a name="input_endpoint_management"></a> [endpoint\_management](#input\_endpoint\_management) | Whether MWAA manages the endpoint (SERVICE) or the customer manages it (CUSTOMER). | `string` | `"SERVICE"` | no |
| <a name="input_environment_class"></a> [environment\_class](#input\_environment\_class) | Environment class for MWAA (e.g. mw1.small, mw1.medium, mw1.large, mw1.micro). | `string` | `"mw1.small"` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | If `create_iam_role` is false, ARN of the existing MWAA execution role. | `string` | `""` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | ⚠️ Deprecated: use `kms_key_arn`. | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key ARN used for encryption (MWAA env and created S3 bucket). | `string` | `null` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | ⚠️ Deprecated: no longer used. Use `s3_logging.target_bucket` instead. | `string` | `null` | no |
| <a name="input_manage_mwaa_log_group_retention"></a> [manage\_mwaa\_log\_group\_retention](#input\_manage\_mwaa\_log\_group\_retention) | If true, the module will ensure MWAA CloudWatch log groups exist and enforce a retention period.<br/>This works for both new and existing environments: no import is required (Terraform will adopt by name). | `bool` | `false` | no |
| <a name="input_max_webservers"></a> [max\_webservers](#input\_max\_webservers) | Maximum number of webservers (typically 2-5; mw1.micro may allow 1). | `number` | `null` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | Maximum number of workers for autoscaling. | `number` | `10` | no |
| <a name="input_min_webservers"></a> [min\_webservers](#input\_min\_webservers) | Minimum number of webservers (typically 2-5; mw1.micro may allow 1). | `number` | `null` | no |
| <a name="input_min_workers"></a> [min\_workers](#input\_min\_workers) | Minimum number of workers. | `number` | `1` | no |
| <a name="input_mwaa_log_group_prevent_destroy"></a> [mwaa\_log\_group\_prevent\_destroy](#input\_mwaa\_log\_group\_prevent\_destroy) | If true, prevent Terraform from destroying MWAA log groups managed for retention. | `bool` | `true` | no |
| <a name="input_mwaa_log_group_tags"></a> [mwaa\_log\_group\_tags](#input\_mwaa\_log\_group\_tags) | Additional tags to apply to MWAA log groups (merged with var.tags). | `map(string)` | `{}` | no |
| <a name="input_mwaa_log_retention_in_days"></a> [mwaa\_log\_retention\_in\_days](#input\_mwaa\_log\_retention\_in\_days) | Retention (in days) to apply to MWAA CloudWatch log groups when manage\_mwaa\_log\_group\_retention=true. | `number` | `30` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | ARN of the permissions boundary to apply to the created MWAA execution role. If null, no boundary is applied. | `string` | `null` | no |
| <a name="input_plugins_s3_object_version"></a> [plugins\_s3\_object\_version](#input\_plugins\_s3\_object\_version) | S3 object version for plugins archive (optional). | `string` | `null` | no |
| <a name="input_plugins_s3_path"></a> [plugins\_s3\_path](#input\_plugins\_s3\_path) | Relative path to plugins archive (e.g. plugins.zip). If null/empty, defaults to plugins.zip. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Additional IAM policy JSON to merge into the MWAA execution role policy (not an S3 bucket policy). | `string` | `null` | no |
| <a name="input_requirements_s3_object_version"></a> [requirements\_s3\_object\_version](#input\_requirements\_s3\_object\_version) | S3 object version for requirements file (optional). | `string` | `null` | no |
| <a name="input_requirements_s3_path"></a> [requirements\_s3\_path](#input\_requirements\_s3\_path) | Relative path to requirements file (e.g. requirements.txt). If null/empty, defaults to requirements.txt. | `string` | `null` | no |
| <a name="input_role_prefix"></a> [role\_prefix](#input\_role\_prefix) | Prefix used when naming the created IAM role. | `string` | `"app"` | no |
| <a name="input_s3_lifecycle_rule"></a> [s3\_lifecycle\_rule](#input\_s3\_lifecycle\_rule) | Lifecycle rules for the created S3 bucket. | `any` | `[]` | no |
| <a name="input_s3_logging"></a> [s3\_logging](#input\_s3\_logging) | S3 server access logging configuration. Disabled when null. | <pre>object({<br/>    target_bucket = string<br/>    target_prefix = string<br/>    target_object_key_format = optional(object({<br/>      format_type           = optional(string)<br/>      partition_date_source = optional(string, "DeliveryTime")<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_scheduler_logs_enabled"></a> [scheduler\_logs\_enabled](#input\_scheduler\_logs\_enabled) | Enable scheduler logs. | `bool` | `false` | no |
| <a name="input_scheduler_logs_level"></a> [scheduler\_logs\_level](#input\_scheduler\_logs\_level) | Scheduler log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG. | `string` | `"INFO"` | no |
| <a name="input_schedulers"></a> [schedulers](#input\_schedulers) | Number of Airflow schedulers (Airflow v2+). Valid range: 2-5 (or null to use AWS default). | `number` | `null` | no |
| <a name="input_secrets_manager_secret_arns"></a> [secrets\_manager\_secret\_arns](#input\_secrets\_manager\_secret\_arns) | List of Secrets Manager secret ARNs the MWAA role may read. If empty, access defaults to '*'. | `list(string)` | `[]` | no |
| <a name="input_security_group_egress_cidr_blocks"></a> [security\_group\_egress\_cidr\_blocks](#input\_security\_group\_egress\_cidr\_blocks) | CIDR blocks allowed for egress from the created security group. Default is open egress (often required for package installs). | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_source_bucket_arn"></a> [source\_bucket\_arn](#input\_source\_bucket\_arn) | If `create_s3_bucket` is false, ARN of the existing S3 bucket used by MWAA. | `string` | `null` | no |
| <a name="input_sqs_queue_arns"></a> [sqs\_queue\_arns](#input\_sqs\_queue\_arns) | Explicit list of SQS queue ARNs used by the MWAA role. If empty, defaults to account-scoped airflow-celery-*. | `list(string)` | `[]` | no |
| <a name="input_startup_script_s3_path"></a> [startup\_script\_s3\_path](#input\_startup\_script\_s3\_path) | Relative path to startup script (e.g. startup.sh). If null/empty, defaults to startup.sh. | `string` | `null` | no |
| <a name="input_startup_script_s3_path_version"></a> [startup\_script\_s3\_path\_version](#input\_startup\_script\_s3\_path\_version) | S3 object version for startup script (optional). | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_task_logs_enabled"></a> [task\_logs\_enabled](#input\_task\_logs\_enabled) | Enable task logs. | `bool` | `false` | no |
| <a name="input_task_logs_level"></a> [task\_logs\_level](#input\_task\_logs\_level) | Task log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG. | `string` | `"INFO"` | no |
| <a name="input_trusting_accounts"></a> [trusting\_accounts](#input\_trusting\_accounts) | ⚠️ Deprecated/unused: has no effect. | `list(string)` | `[]` | no |
| <a name="input_webserver_access_mode"></a> [webserver\_access\_mode](#input\_webserver\_access\_mode) | Webserver accessibility mode. Valid values: PRIVATE\_ONLY (default) or PUBLIC\_ONLY. | `string` | `"PRIVATE_ONLY"` | no |
| <a name="input_webserver_logs_enabled"></a> [webserver\_logs\_enabled](#input\_webserver\_logs\_enabled) | Enable webserver logs. | `bool` | `false` | no |
| <a name="input_webserver_logs_level"></a> [webserver\_logs\_level](#input\_webserver\_logs\_level) | Webserver log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG. | `string` | `"INFO"` | no |
| <a name="input_weekly_maintenance_window_start"></a> [weekly\_maintenance\_window\_start](#input\_weekly\_maintenance\_window\_start) | Start time for the weekly maintenance window. | `string` | `null` | no |
| <a name="input_worker_logs_enabled"></a> [worker\_logs\_enabled](#input\_worker\_logs\_enabled) | Enable worker logs. | `bool` | `false` | no |
| <a name="input_worker_logs_level"></a> [worker\_logs\_level](#input\_worker\_logs\_level) | Worker log level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG. | `string` | `"INFO"` | no |
| <a name="input_worker_replacement_strategy"></a> [worker\_replacement\_strategy](#input\_worker\_replacement\_strategy) | Worker replacement strategy during updates. Valid values: FORCED, GRACEFUL. | `string` | `"GRACEFUL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the MWAA Environment. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Creation timestamp of the MWAA Environment. |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | IAM Role ARN for the MWAA execution role (created or provided). |
| <a name="output_kms_key_deprecation"></a> [kms\_key\_deprecation](#output\_kms\_key\_deprecation) | n/a |
| <a name="output_log_bucket_deprecation"></a> [log\_bucket\_deprecation](#output\_log\_bucket\_deprecation) | Deprecation warnings kept because you asked for them previously. |
| <a name="output_logging_configuration"></a> [logging\_configuration](#output\_logging\_configuration) | Logging configuration of the MWAA Environment. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the S3 bucket used by MWAA (created or provided). |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the security group created by this module (null if create\_security\_group=false). |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group created by this module (null if create\_security\_group=false). |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the security group created by this module (null if create\_security\_group=false). |
| <a name="output_service_role_arn"></a> [service\_role\_arn](#output\_service\_role\_arn) | Service role ARN of the MWAA Environment. |
| <a name="output_status"></a> [status](#output\_status) | Current status of the MWAA Environment. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | All tags assigned to the MWAA Environment. |
| <a name="output_trusting_accounts_deprecation"></a> [trusting\_accounts\_deprecation](#output\_trusting\_accounts\_deprecation) | n/a |
| <a name="output_webserver_url"></a> [webserver\_url](#output\_webserver\_url) | Webserver URL of the MWAA Environment. |
<!-- END_TF_DOCS -->