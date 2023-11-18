
resource "aws_eks_cluster" "my-eks-cluster" {
  name     = var.cluster_name
  role_arn = var.eks-role
  version = "1.23"

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids = var.cluster-security-group

  }

  enabled_cluster_log_types = ["api", "audit"]
}











