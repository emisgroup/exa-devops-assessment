# EKS
resource "aws_eks_cluster" "emistest_EKS_cluster" {
  name      = "emistest-EKS-Cluster"
  role_arn  = aws_iam_role.emistest_EKS_cluster_role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.PolicyAttachment_emistest_EKS_Cluster,
    aws_iam_role_policy_attachment.PolicyAttachment_emistest_EKS_Pods
  ]
}

resource "aws_iam_openid_connect_provider" "emistest_oicd_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.emistest_eks_cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.emistest_EKS_cluster.identity[0].oidc[0].issuer
}

data "tls_certificate" "emistest_eks_cert" {
  url = "${aws_eks_cluster.emistest_EKS_cluster.identity.0.oidc.0.issuer}"
}


# Fargate
resource "aws_eks_fargate_profile" "emistest_EKS_fargate_profile" {
  cluster_name            = aws_eks_cluster.emistest_EKS_cluster.id
  fargate_profile_name    = "emistest_Fargate_Profile"
  pod_execution_role_arn  = aws_iam_role.emistest_fargate_profile.arn
  subnet_ids              = module.vpc.private_subnets

  selector {
    namespace = "emistest"
  }
}

# CoreDNS
resource "aws_eks_fargate_profile" "emistest_coredns_fargateprofile" {
  cluster_name            = aws_eks_cluster.emistest_EKS_cluster.id
  fargate_profile_name    = "emistest_CoreDNS_Fargate_Profile"
  pod_execution_role_arn  = aws_iam_role.emistest_fargate_profile.arn
  subnet_ids              = module.vpc.private_subnets

  selector {
    namespace = "kube-system"

    labels = {
      "k8s-app"                     = "kube-dns"
      "eks.amazonaws.com/component" = "coredns"
    }
  }
}


# Outputs
output "emistest_eks_cluster_endpoint" {
  value = aws_eks_cluster.emistest_EKS_cluster.endpoint
}

output "emistest_eks_cluster_CA" {
  value = aws_eks_cluster.emistest_EKS_cluster.certificate_authority
}

output "emistest_eks_cluster_id" {
  value = aws_eks_cluster.emistest_EKS_cluster.id
}

output "emistest_eks_cluster_oidc_issuer" {
  value = aws_eks_cluster.emistest_EKS_cluster.identity.0.oidc.0.issuer
}

output "emistest_openidconnect_arn" {
  value = aws_iam_openid_connect_provider.emistest_oicd_provider.arn
}

output "emistest_openidconnect_url" {
  value = aws_iam_openid_connect_provider.emistest_oicd_provider.url
}



