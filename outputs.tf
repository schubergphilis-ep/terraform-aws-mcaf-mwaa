############################################
# Outputs
############################################

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket used by MWAA (created or provided)."
  value       = local.s3_bucket_arn
}

output "execution_role_arn" {
  description = "IAM Role ARN for the MWAA execution role (created or provided)."
  value       = local.execution_role_arn
}

output "arn" {
  description = "ARN of the MWAA Environment."
  value       = aws_mwaa_environment.default.arn
}

output "created_at" {
  description = "Creation timestamp of the MWAA Environment."
  value       = aws_mwaa_environment.default.created_at
}

output "logging_configuration" {
  description = "Logging configuration of the MWAA Environment."
  value       = aws_mwaa_environment.default.logging_configuration
}

output "service_role_arn" {
  description = "Service role ARN of the MWAA Environment."
  value       = aws_mwaa_environment.default.service_role_arn
}

output "status" {
  description = "Current status of the MWAA Environment."
  value       = aws_mwaa_environment.default.status
}

output "tags_all" {
  description = "All tags assigned to the MWAA Environment."
  value       = aws_mwaa_environment.default.tags_all
}

output "webserver_url" {
  description = "Webserver URL of the MWAA Environment."
  value       = aws_mwaa_environment.default.webserver_url
}

############################################
# Security group outputs
# Guarded so plans do not fail when create_security_group = false
############################################

output "security_group_id" {
  description = "ID of the security group created by this module (null if create_security_group=false)."
  value       = var.create_security_group ? aws_security_group.mwaa[0].id : null
}

output "security_group_arn" {
  description = "ARN of the security group created by this module (null if create_security_group=false)."
  value       = var.create_security_group ? aws_security_group.mwaa[0].arn : null
}

output "security_group_name" {
  description = "Name of the security group created by this module (null if create_security_group=false)."
  value       = var.create_security_group ? aws_security_group.mwaa[0].name : null
}
