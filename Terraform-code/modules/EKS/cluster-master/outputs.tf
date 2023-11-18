
output "endpoint" {
  value = aws_eks_cluster.my-eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-eks-cluster.certificate_authority[0].data
}

output "eks-cluster-name" {
  value = aws_eks_cluster.my-eks-cluster.name
}