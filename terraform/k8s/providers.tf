provider aws {
  region = "us-east-1"
  
  default_tags {
      tags = {
          terraform = "true/github"
          use = "EMIS/KCM"
      }
  }
}

data "terraform_remote_state" "main_tf" {
  backend = "s3"
  config = {
      bucket = "kanchimoe-emistest"
      key    = "terraform/emistest/main"
      region = "us-east-1"
  }
}

terraform {
  backend "s3" {
    bucket = "kanchimoe-emistest"
    key    = "terraform/emistest/k8s"
    region = "us-east-1"
  }
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "aws_eks_cluster_auth" "emistest_eks_cluster_auth" {
    name = data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_id
}

provider "kubernetes" {
    host                   = data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_CA[0].data)
    token                  = data.aws_eks_cluster_auth.emistest_eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_endpoint
    token                  = data.aws_eks_cluster_auth.emistest_eks_cluster_auth.token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_CA[0].data)
  }
}

module "lb-controller" {
  source       = "Young-ook/eks/aws//modules/lb-controller"
  cluster_name = data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_id
  oidc         = zipmap(
    ["url", "arn"],
    [data.terraform_remote_state.main_tf.outputs.emistest_openidconnect_url, replace(data.terraform_remote_state.main_tf.outputs.emistest_openidconnect_arn, "https://", "")]
  )
  tags         = { env = "test" }
}







