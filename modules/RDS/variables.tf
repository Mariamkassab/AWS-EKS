variable "engine-name" {
  type = string
}

variable "db-name" {
  type = string
}

variable "storage" {
  type = string
}

variable "engine-v" {
  type = any
}

variable "instance-type" {
  type = string
}

variable "user" {
  type = any
}

variable "subnet-vpc-id" {
  type = any
}
variable "skip-final-db-snapshot" {
  type = bool
}

variable "db-security-group" {
  type = any
}

variable "max_allocated_storage-autoscalling" {
  type = any
}

variable "monitoring_interval" {
  type = any
}

variable "maintenance_window" {
  type = any
}

variable "backup_window" {
  type = any
}

variable "backup_retention_period" {
  type = any
}

variable "secret-name" {
  type = string
}

variable "rds-enhanced-monitoring-role" {
  type = string
}