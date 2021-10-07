resource "aws_ecr_repository" "emistest_ecr" {
    name = "emistest-ecr"
    image_tag_mutability = "MUTABLE"

    encryption_configuration {
        encryption_type = "KMS"
        kms_key         = aws_kms_key.emistest_kms_key.arn
    }
}

output "emistest_ecr_url" {
  value = aws_ecr_repository.emistest_ecr.repository_url
}

data "aws_ecr_authorization_token" "emistest-ecr-authtoken" {
}