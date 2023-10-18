# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

#VPC variable
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

#public subnet availabilty zone 1 cidr variable
variable "public_subnet_az1_cidr" {
  description = "public subnet availabilty zone one cidr"
  type        = string
}

#public subnet availabilty zone 2 cidr variable
variable "public_subnet_az2_cidr" {
  description = "public subnet availabilty zone two cidr"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  description = "The AMI to use"
  type        = string
}

variable "number_of_instances" {
  description = "number of instances to be created"
  type        = number
}


variable "ami_key_pair_name" {
  type = string
}

variable "ec2_counter" {
  default = 0
  type    = number
}

#security-group variable
variable "ssh_location" {
  description = "ip address that can ssh into the server"
  type        = string
}

#acm and Route53 variables
variable "domain_name" {
  description = "domain name "
  type        = string
}

variable "nlb_acm_cert_arn" {
  description = "acm certificate for the network load balancer"
  type        = string
}

variable "route53_hosted_zone_id" {
  description = "The ID of the hosted zone to contain this record."
  type        = string
}

#wazuh manager variables
variable "wazuh_manager_ecr_image" {
  description = "wazuh manager barefoot cyber docker image url"
  type        = string
}
