## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
|  [aws](#provider\_aws) | 4.59.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
|  [iam\_role](#module\_iam\_role) | github.com/schubergphilis/terraform-aws-mcaf-role | v0.3.2 |
|  [s3\_bucket](#module\_s3\_bucket) | github.com/sbpdvb/terraform-aws-mcaf-s3 | v0.6.1 |

## Resources

| Name | Type |
|------|------|
| [aws_mwaa_environment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment) | resource |
| [aws_security_group.mwaa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|  [airflow\_configuration\_options](#input\_airflow\_configuration\_options) | The Airflow override options | `any` | `null` | no |
|  [airflow\_version](#input\_airflow\_version) | Airflow version of the MWAA environment. | `string` | n/a | yes |
|  [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of IPv4 CIDRs to allow access to the security group created by this module.The length of this list must be known at "plan" time. | `list(string)` | `[]` | no |
|  [associated\_security\_group\_ids](#input\_associated\_security\_group\_ids) | A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access. | `list(string)` | `[]` | no |
|  [create\_iam\_role](#input\_create\_iam\_role) | Enabling or disabling the creatation of a default IAM Role for AWS MWAA | `bool` | `true` | no |
|  [create\_s3\_bucket](#input\_create\_s3\_bucket) | Enabling or disabling the creatation of an S3 bucket for AWS MWAA | `bool` | `true` | no |
|  [create\_security\_group](#input\_create\_security\_group) | Enabling or disabling the creatation of a default SecurityGroup for AWS MWAA | `bool` | `true` | no |
|  [dag\_processing\_logs\_enabled](#input\_dag\_processing\_logs\_enabled) | Enabling or disabling the collection of logs for processing DAGs | `bool` | `false` | no |
|  [dag\_processing\_logs\_level](#input\_dag\_processing\_logs\_level) | DAG processing logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
|  [dag\_s3\_path](#input\_dag\_s3\_path) | The relative path to the DAG folder on your Amazon S3 storage bucket. | `string` | `"dags"` | no |
|  [environment\_class](#input\_environment\_class) | Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large. | `string` | `"mw1.small"` | no |
|  [execution\_role\_arn](#input\_execution\_role\_arn) | If `create_iam_role` is `false` then set this to the target MWAA execution role | `string` | `""` | no |
|  [endpoint_management](#input\_endpoint_management) | Specifies whether the environment should be managed by MWAA. Possible options: SERVICE (default) or CUSTOMER. | `string` | `"SERVICE"` | no |
|  [kms\_key](#input\_kms\_key) | The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption. Will be set to the ARN of the managed KMS key aws/airflow by default. | `string` | `null` | no |
|  [kms_key_arn](#input\_kms_key_arn) | The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption. | `string` | `null` | no |
|  [log\_bucket](#input\_log\_bucket) | n/a | `string` | `null` | no |
|  [max\_workers](#input\_max\_workers) | The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25. | `number` | `10` | no |
|  [min\_workers](#input\_min\_workers) | The minimum number of workers that you want to run in your environment. | `number` | `1` | no |
|  [name](#input\_name) | n/a | `string` | n/a | yes |
|  [plugins\_s3\_object\_version](#input\_plugins\_s3\_object\_version) | The plugins.zip file version you want to use. | `string` | `null` | no |
|  [plugins\_s3\_path](#input\_plugins\_s3\_path) | The relative path to the plugins.zip file on your Amazon S3 storage bucket. For example, plugins.zip. If a relative path is provided in the request, then plugins\_s3\_object\_version is required | `string` | `null` | no |
|  [policy](#policy) |  A valid bucket policy JSON document. | `string` | `null` | no |
|  [requirements\_s3\_object\_version](#input\_requirements\_s3\_object\_version) | The requirements.txt file version you want to use. | `string` | `null` | no |
|  [requirements\_s3\_path](#input\_requirements\_s3\_path) | The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. If a relative path is provided in the request, then requirements\_s3\_object\_version is required | `string` | `null` | no |
|  [scheduler\_logs\_enabled](#input\_scheduler\_logs\_enabled) | Enabling or disabling the collection of logs for the schedulers | `bool` | `false` | no |
|  [scheduler\_logs\_level](#input\_scheduler\_logs\_level) | Schedulers logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
|  [source\_bucket\_arn](#input\_source\_bucket\_arn) | If `create_s3_bucket` is `false` then set this to the Amazon Resource Name (ARN) of your Amazon S3 storage bucket. | `string` | `null` | no |
|  [startup\_script\_s3\_path](#input\_startup\_script\_s3\_path) | The relative path to the startup script on your Amazon S3 storage bucket. For example, startup.sh. | `string` | `null` | no |
|  [subnet\_ids](#input\_subnet\_ids) | The private subnet IDs in which the environment should be created. MWAA requires two subnets | `list(string)` | n/a | yes |
|  [tags](#input\_tags) | n/a | `map` | `{}` | no |
|  [task\_logs\_enabled](#input\_task\_logs\_enabled) | Enabling or disabling the collection of logs for DAG tasks | `bool` | `false` | no |
|  [task\_logs\_level](#input\_task\_logs\_level) | DAG tasks logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
|  [trusting\_accounts](#input\_trusting\_accounts) | Account IDs that will trust this MWAA cluster to assume roles. | `list(string)` | `[]` | no |
|  [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |
|  [webserver\_access\_mode](#input\_webserver\_access\_mode) | Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE\_ONLY (default) and PUBLIC\_ONLY. | `string` | `"PRIVATE_ONLY"` | no |
|  [webserver\_logs\_enabled](#input\_webserver\_logs\_enabled) | Enabling or disabling the collection of logs for the webservers | `bool` | `false` | no |
|  [webserver\_logs\_level](#input\_webserver\_logs\_level) | Webserver logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
|  [weekly\_maintenance\_window\_start](#input\_weekly\_maintenance\_window\_start) | Specifies the start date for the weekly maintenance window. | `string` | `null` | no |
|  [worker\_logs\_enabled](#input\_worker\_logs\_enabled) | Enabling or disabling the collection of logs for the workers | `bool` | `false` | no |
|  [worker\_logs\_level](#input\_worker\_logs\_level) | Workers logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |

## Outputs

| Name | Description |
|------|-------------|
|  [arn](#output\_arn) | The ARN of the Amazon MWAA Environment |
|  [created\_at](#output\_created\_at) | The Created At date of the Amazon MWAA Environment |
|  [execution\_role\_arn](#output\_execution\_role\_arn) | IAM Role ARN for Amazon MWAA Execution Role |
|  [logging\_configuration](#output\_logging\_configuration) | The Logging Configuration of the Amazon MWAA Environment |
|  [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the S3 bucket |
|  [security\_group\_arn](#output\_security\_group\_arn) | The ARN of the created security group |
|  [security\_group\_id](#output\_security\_group\_id) | The ID of the created security group |
|  [security\_group\_name](#output\_security\_group\_name) | The name of the created security group |
|  [service\_role\_arn](#output\_service\_role\_arn) | The Service Role ARN of the Amazon MWAA Environment |
|  [status](#output\_status) | The status of the Amazon MWAA Environment |
|  [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider for the Amazon MWAA Environment |
|  [webserver\_url](#output\_webserver\_url) | The webserver URL of the Amazon MWAA Environment |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_role"></a> [iam\_role](#module\_iam\_role) | schubergphilis/mcaf-role/aws | 0.5.3 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | schubergphilis/mcaf-s3/aws | 2.0.0 |

## Resources

| Name | Type |
|------|------|
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
| <a name="input_airflow_configuration_options"></a> [airflow\_configuration\_options](#input\_airflow\_configuration\_options) | The Airflow override options | `any` | `null` | no |
| <a name="input_airflow_version"></a> [airflow\_version](#input\_airflow\_version) | Airflow version of the MWAA environment. | `string` | n/a | yes |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of IPv4 CIDRs to allow access to the security group created by this module.<br/>The length of this list must be known at "plan" time. | `list(string)` | `[]` | no |
| <a name="input_associated_security_group_ids"></a> [associated\_security\_group\_ids](#input\_associated\_security\_group\_ids) | A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.<br/>These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access. | `list(string)` | `[]` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Enabling or disabling the creatation of a default IAM Role for AWS MWAA | `bool` | `true` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Enabling or disabling the creatation of an S3 bucket for AWS MWAA | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Enabling or disabling the creatation of a default SecurityGroup for AWS MWAA | `bool` | `true` | no |
| <a name="input_dag_bucket_policy"></a> [dag\_bucket\_policy](#input\_dag\_bucket\_policy) | A valid dag bucket policy JSON document | `string` | `null` | no |
| <a name="input_dag_processing_logs_enabled"></a> [dag\_processing\_logs\_enabled](#input\_dag\_processing\_logs\_enabled) | Enabling or disabling the collection of logs for processing DAGs | `bool` | `false` | no |
| <a name="input_dag_processing_logs_level"></a> [dag\_processing\_logs\_level](#input\_dag\_processing\_logs\_level) | DAG processing logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
| <a name="input_dag_s3_path"></a> [dag\_s3\_path](#input\_dag\_s3\_path) | The relative path to the DAG folder on your Amazon S3 storage bucket. | `string` | `"dags"` | no |
| <a name="input_endpoint_management"></a> [endpoint\_management](#input\_endpoint\_management) | Let MWAA manage the endpoint or not. Possible values: SERVICE, CUSTOMER | `string` | `"SERVICE"` | no |
| <a name="input_environment_class"></a> [environment\_class](#input\_environment\_class) | Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large. | `string` | `"mw1.small"` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | If `create_iam_role` is `false` then set this to the target MWAA execution role | `string` | `""` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption. Will be set to the ARN of the managed KMS key aws/airflow by default. | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to use for encryption | `string` | `null` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | n/a | `string` | `null` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25. | `number` | `10` | no |
| <a name="input_min_workers"></a> [min\_workers](#input\_min\_workers) | The minimum number of workers that you want to run in your environment. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | Will be deprecated in future version | `string` | `null` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | ARN of the permissions boundary to apply to the created MWAA execution role. If null, no boundary is applied. | `string` | `null` | no |
| <a name="input_plugins_s3_object_version"></a> [plugins\_s3\_object\_version](#input\_plugins\_s3\_object\_version) | The plugins.zip file version you want to use. | `string` | `null` | no |
| <a name="input_plugins_s3_path"></a> [plugins\_s3\_path](#input\_plugins\_s3\_path) | The relative path to the plugins.zip file on your Amazon S3 storage bucket. For example, plugins.zip. If a relative path is provided in the request, then plugins\_s3\_object\_version is required | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | A valid bucket policy JSON document | `string` | `null` | no |
| <a name="input_requirements_s3_object_version"></a> [requirements\_s3\_object\_version](#input\_requirements\_s3\_object\_version) | The requirements.txt file version you want to use. | `string` | `null` | no |
| <a name="input_requirements_s3_path"></a> [requirements\_s3\_path](#input\_requirements\_s3\_path) | The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. If a relative path is provided in the request, then requirements\_s3\_object\_version is required | `string` | `null` | no |
| <a name="input_role_prefix"></a> [role\_prefix](#input\_role\_prefix) | Prefix for the IAM role | `string` | `"app"` | no |
| <a name="input_s3_lifecycle_rule"></a> [s3\_lifecycle\_rule](#input\_s3\_lifecycle\_rule) | List of maps containing lifecycle management configuration settings. | `any` | `[]` | no |
| <a name="input_s3_logging"></a> [s3\_logging](#input\_s3\_logging) | Logging configuration, logging is disabled by default. | <pre>object({<br/>    target_bucket = string<br/>    target_prefix = string<br/>    target_object_key_format = optional(object({<br/>      format_type           = optional(string)                 # "simple" or "partitioned"<br/>      partition_date_source = optional(string, "DeliveryTime") # Required if format_type is "partitioned", default is DeliveryTime<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_scheduler_logs_enabled"></a> [scheduler\_logs\_enabled](#input\_scheduler\_logs\_enabled) | Enabling or disabling the collection of logs for the schedulers | `bool` | `false` | no |
| <a name="input_scheduler_logs_level"></a> [scheduler\_logs\_level](#input\_scheduler\_logs\_level) | Schedulers logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
| <a name="input_schedulers"></a> [schedulers](#input\_schedulers) | Number of Airflow schedulers (Airflow v2+). Valid range: 2-5 (or null to use AWS default). | `number` | `null` | no |
| <a name="input_source_bucket_arn"></a> [source\_bucket\_arn](#input\_source\_bucket\_arn) | If `create_s3_bucket` is `false` then set this to the Amazon Resource Name (ARN) of your Amazon S3 storage bucket. | `string` | `null` | no |
| <a name="input_startup_script_s3_path"></a> [startup\_script\_s3\_path](#input\_startup\_script\_s3\_path) | The relative path to the startup script on your Amazon S3 storage bucket. For example, startup.sh | `string` | `null` | no |
| <a name="input_startup_script_s3_path_version"></a> [startup\_script\_s3\_path\_version](#input\_startup\_script\_s3\_path\_version) | The version of the startup script on your Amazon S3 storage bucket. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The private subnet IDs in which the environment should be created. MWAA requires two subnets | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_task_logs_enabled"></a> [task\_logs\_enabled](#input\_task\_logs\_enabled) | Enabling or disabling the collection of logs for DAG tasks | `bool` | `false` | no |
| <a name="input_task_logs_level"></a> [task\_logs\_level](#input\_task\_logs\_level) | DAG tasks logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
| <a name="input_trusting_accounts"></a> [trusting\_accounts](#input\_trusting\_accounts) | Account IDs that will trust this MWAA cluster to assume roles. | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |
| <a name="input_webserver_access_mode"></a> [webserver\_access\_mode](#input\_webserver\_access\_mode) | Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE\_ONLY (default) and PUBLIC\_ONLY. | `string` | `"PRIVATE_ONLY"` | no |
| <a name="input_webserver_logs_enabled"></a> [webserver\_logs\_enabled](#input\_webserver\_logs\_enabled) | Enabling or disabling the collection of logs for the webservers | `bool` | `false` | no |
| <a name="input_webserver_logs_level"></a> [webserver\_logs\_level](#input\_webserver\_logs\_level) | Webserver logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |
| <a name="input_weekly_maintenance_window_start"></a> [weekly\_maintenance\_window\_start](#input\_weekly\_maintenance\_window\_start) | Specifies the start date for the weekly maintenance window. | `string` | `null` | no |
| <a name="input_worker_logs_enabled"></a> [worker\_logs\_enabled](#input\_worker\_logs\_enabled) | Enabling or disabling the collection of logs for the workers | `bool` | `false` | no |
| <a name="input_worker_logs_level"></a> [worker\_logs\_level](#input\_worker\_logs\_level) | Workers logging level. Valid values: CRITICAL, ERROR, WARNING, INFO, DEBUG | `string` | `"INFO"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the Amazon MWAA Environment |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | The Created At date of the Amazon MWAA Environment |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | IAM Role ARN for Amazon MWAA Execution Role |
| <a name="output_logging_configuration"></a> [logging\_configuration](#output\_logging\_configuration) | The Logging Configuration of the Amazon MWAA Environment |
| <a name="output_permissions_boundary_deprecation"></a> [permissions\_boundary\_deprecation](#output\_permissions\_boundary\_deprecation) | n/a |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the S3 bucket |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | The ARN of the created security group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the created security group |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | The name of the created security group |
| <a name="output_service_role_arn"></a> [service\_role\_arn](#output\_service\_role\_arn) | The Service Role ARN of the Amazon MWAA Environment |
| <a name="output_status"></a> [status](#output\_status) | The status of the Amazon MWAA Environment |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider for the Amazon MWAA Environment |
| <a name="output_webserver_url"></a> [webserver\_url](#output\_webserver\_url) | The webserver URL of the Amazon MWAA Environment |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
