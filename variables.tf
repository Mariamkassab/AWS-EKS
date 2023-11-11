# provider
variable "aws-region" {}


#vpc
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "gw_name" {}


#subnets
variable "subnet_cidr" {
    type = list  
}
variable "subnet_name" {
  type = list
}
variable "az" {
  type = list
}


#nat
variable "nat_name" {}


# # lb security groupe
# variable "lb-ec2-cidr" {
#   type = list
# }

# # endpoint security group
# variable "endpoint-ssh-cidr" {
#   type = list
# }


#public rt
variable "pub-wanted-cidr" {}
variable "pub-table-name" {}

#private rt
variable "pri-wanted-cidr" {}
variable "pri-table-name" {}

#eks-cluster
variable "cluster_name" {}
variable "node_group_name" {}

# rds
variable "engine-name" {}
variable "db-name" {}
variable "storage" {}
variable "engine-v" {}
variable "instance-type" {}
variable "user" {}

variable "skip-final-db-snapshot" {
  type = bool
}
variable "max_allocated_storage-autoscalling" {}
variable "monitoring_interval" {}
variable "maintenance_window" {}
variable "backup_window" {}
variable "backup_retention_period" {}
variable "secret-name" {}
variable "rds-enhanced-monitoring-role" {}


