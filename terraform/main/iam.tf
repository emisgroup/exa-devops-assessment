# EKS cluster
resource "aws_iam_role" "emistest_EKS_cluster_role" {
    name               = "emistest-eks-cluster"
    description        = "EMIS test EKS Cluster role"
    assume_role_policy = data.aws_iam_policy_document.emistest_ekscluster_assume_role.json
}


data "aws_iam_policy_document" "emistest_ekscluster_assume_role" {
    statement {
        actions = [
           "sts:AssumeRole" 
        ]
        principals {
            type = "Service"
            identifiers = ["eks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "PolicyAttachment_emistest_EKS_Cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.emistest_EKS_cluster_role.name
}


## Pods
resource "aws_iam_role_policy_attachment" "PolicyAttachment_emistest_EKS_Pods" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role       = aws_iam_role.emistest_EKS_cluster_role.name
}


# Fargate
resource "aws_iam_role" "emistest_fargate_profile" {
    name               = "emistest-fargate-profile"
    description        = "EMIS test fargate profile role"
    assume_role_policy = data.aws_iam_policy_document.emistest_fargateprofile_assume_role.json
}

data "aws_iam_policy_document" "emistest_fargateprofile_assume_role" {
    statement {
        actions = [
            "sts:AssumeRole"
        ]
        principals {
            type = "Service"
            identifiers = ["eks-fargate-pods.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "PolicyAttachment_emistest_fargate_profile" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.emistest_fargate_profile.name
}

























