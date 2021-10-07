provider aws {
  region = "us-east-1"
  
  default_tags {
      tags = {
          terraform = "true/github"
          use = "EMIS/KCM"
      }
  }
}

terraform {
  backend "s3" {
    bucket = "kanchimoe-emistest"
    key    = "terraform/emistest/main"
    region = "us-east-1"
  }
}

resource "aws_kms_key" "emistest_kms_key" {
  description             = "KMS key for EMIS test"
  deletion_window_in_days = 7
}



