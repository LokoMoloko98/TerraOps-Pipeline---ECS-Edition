# create security group for the wazuh_security_group load balancer
resource "aws_security_group" "wazuh_security_group" {
  name        = "${var.project_name}-${var.environment}-wazuh-sg"
  description = "enable wazuh ports access"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-${var.environment}-wazuh-sg"
  }
}

# create ingress rules
resource "aws_vpc_security_group_ingress_rule" "wzh_http_ingress" {
  security_group_id = aws_security_group.wazuh_security_group.id
  description       = "https access"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wzh_agents_ingress" {
  security_group_id = aws_security_group.wazuh_security_group.id
  description       = "agent connect"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 1514
  ip_protocol       = "tcp"
  to_port           = 1516
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-agents"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wzh_api" {
  security_group_id = aws_security_group.wazuh_security_group.id
  description       = "Server API Service"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 55000
  to_port           = 55000
  ip_protocol       = "tcp"
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-api"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wzh_syslog" {
  security_group_id = aws_security_group.wazuh_security_group.id
  description       = "Syslog"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6514
  to_port           = 6514
  ip_protocol       = "tcp"
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-syslog"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wzh_dashboard" {
  security_group_id = aws_security_group.wazuh_security_group.id
  description       = "dashboard"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5601
  to_port           = 5601
  ip_protocol       = "tcp"
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-syslog"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wzh_indexer" {
  security_group_id = aws_security_group.wazuh_security_group.id
  description       = "Indexer access"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9200
  to_port           = 9200
  ip_protocol       = "tcp"
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-indexer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wzh_ssh" {
  security_group_id = aws_security_group.wazuh_security_group.id
  description       = "Secure Shell (SSH)"
  cidr_ipv4         = var.ssh_location
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-ssh"
  }
}

# create single egress rule for all AZs
resource "aws_vpc_security_group_egress_rule" "wzh_egress" {
  security_group_id = aws_security_group.wazuh_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  tags = {
    Name = "${var.project_name}-${var.environment}-wzh-lb-out"
  }
}