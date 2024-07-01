/* #######################################################
Main EKS Cluster

Subnets:
    Master Nodes: Isolated
    Worker Nodes: Private

Worker Nodes:
    Min: 1
    Max: 3
    Desirable: 1
    Instance Type: t3.large

Access Entry:
    Policies:
        arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy
        arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy

########################################################*/
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                   = "${var.project_name}-VTC_Service"
  cluster_version                = "1.30"
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = aws_vpc.VTC-Service.id
  subnet_ids               = [aws_subnet.VTC_Service-private-AZ_A.id, aws_subnet.VTC_Service-private-AZ_B.id]
  control_plane_subnet_ids = [aws_subnet.VTC_Service-isolate-AZ_A.id, aws_subnet.VTC_Service-isolate-AZ_B.id]

  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    instance_types                        = ["m5.large"]
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    main-wg = {
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  access_entries = {
    Main = {
      kubernetes_groups = []
      principal_arn     = "${var.eks-access-role-arn}"

      policy_associations = {
        eksadmin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
        clusteradmin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }
  
  depends_on = [
    aws_subnet.VTC_Service-private-AZ_A,
    aws_subnet.VTC_Service-private-AZ_B,
    aws_internet_gateway.VTC-Service,
    aws_nat_gateway.VTC_Service-private-AZ_A,
    aws_nat_gateway.VTC_Service-private-AZ_B,
    aws_route_table.VTC_Service-private-AZ_A-Route_Table,
    aws_route_table.VTC_Service-private-AZ_B-Route_Table,
  ]
}
