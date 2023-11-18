output "secretsmanager_secret_retrieve" {
  value = aws_secretsmanager_secret.rds-password.arn
}