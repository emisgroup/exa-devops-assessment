resource "kubernetes_namespace" "emistest_kubernetes_namespace" {
  metadata {
    name = "emistest"

    labels = {
      terraform = "true-github"
      use       = "EMIS-KCM"
    }
  }
}

resource "kubernetes_deployment" "emistest_k8s_deployment" {
  metadata {
    labels = {
      use       = "kcm-emistest"
      terraform = "true-github"
    }
    name      = "emistest-k8s-deployment"
    namespace = kubernetes_namespace.emistest_kubernetes_namespace.metadata.0.name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        use = "kcm-emistest"
      }
    }

    template {
      metadata {
        labels = {
          use = "kcm-emistest"
        }
      }

      spec {
        container {
          image = "647526876872.dkr.ecr.us-east-1.amazonaws.com/emistest-ecr:latest"
          name  = "emis-test"

          resources {
            requests = {
              cpu    = "1"
              memory = "2Gi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.emistest_kubernetes_namespace]
}

resource "kubernetes_service" "emistest_k8s_service" {
  metadata {
    name      = "emistest-k8s-deployment"
    namespace = kubernetes_namespace.emistest_kubernetes_namespace.metadata.0.name
  }

  spec {
    selector = {
      use = "kcm-emistest"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [kubernetes_deployment.emistest_k8s_deployment]
}

#################################################################################

module "load_balancer_controller" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-lb-controller.git"

  cluster_identity_oidc_issuer     = data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_oidc_issuer
  cluster_identity_oidc_issuer_arn = data.terraform_remote_state.main_tf.outputs.emistest_openidconnect_arn
  cluster_name                     = data.terraform_remote_state.main_tf.outputs.emistest_eks_cluster_id

}



