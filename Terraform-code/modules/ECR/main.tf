resource "aws_ecr_repository" "app-reg" {
  name                 = "app-reg"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}