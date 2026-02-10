############################################
# security.tf
#
# Optional Security Group for MWAA.
#
# Default behavior:
# - Ingress 443 only from allowed_cidr_blocks (to reach the Airflow UI)
# - Ingress all from self (MWAA components communicate within the SG)
# - Egress is configurable via security_group_egress_cidr_blocks (default is open egress)
#
# Notes:
# - MWAA often needs outbound access (e.g., to fetch Python packages, reach AWS APIs via endpoints/NAT).
# - If you want stricter control, constrain security_group_egress_cidr_blocks and/or replace this SG
#   by setting create_security_group=false and passing associated_security_group_ids.
############################################

resource "aws_security_group" "mwaa" {
  #checkov:skip=CKV2_AWS_5
  count = var.create_security_group ? 1 : 0

  name        = var.name
  description = "Allow traffic to the MWAA" ## not perfect, but do *NOT* change as this will re-create SG resource!
  vpc_id      = var.vpc_id

  ############################################
  # Ingress: HTTPS access for the Airflow webserver endpoint
  #
  # - For PRIVATE_ONLY, this controls access from within your VPC / peered networks.
  # - For PUBLIC_ONLY, AWS controls the public endpoint; you typically restrict at source.
  ############################################
  ingress {
    description = "HTTPS (443) from allowed CIDRs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ############################################
  # Ingress: allow MWAA components within the same SG to talk to each other
  ############################################
  ingress {
    description = "Allow all traffic within the security group (self-reference)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ############################################
  # Egress: configurable
  #
  # Default is 0.0.0.0/0 (common requirement for package downloads, external endpoints).
  # Tighten this if you route all egress through VPC endpoints / proxies / NAT with controls.
  ############################################
  egress {
    description = "Egress (configurable via security_group_egress_cidr_blocks)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.security_group_egress_cidr_blocks
  }

  tags = var.tags
}
