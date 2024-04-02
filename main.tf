provider "aws" {
  region = "us-east-1"
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "Argocd-Cluster"
  cluster_version = "1.21"
  subnet_ids      = ["subnet-0c8e1eaaaff0a0726", "subnet-095be323bd97dc9a4", "subnet-0e3db30d9fdcb6414"]
  vpc_id          = "vpc-09dc7f1f67be235dc"
  workers_group_defaults = {
    instance_type    = "t2.micro"
    key_name         = "test-1"
  }
  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1
    }
  }
}

resource "null_resource" "eks_cluster_wait" {
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=Ready node --all --timeout=10m"
  }

  depends_on = [module.eks_cluster]
}

