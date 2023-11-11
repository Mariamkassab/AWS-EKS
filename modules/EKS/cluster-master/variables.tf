variable "eks-role" {}
variable "subnet_ids" {
  type = list
}
variable "cluster_name" {}
variable "cluster-security-group" {
  type = list
}