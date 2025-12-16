provider "aws" {
    region = "ap-south-1"
}

# Eks-cluster
resource "aws_eks_cluster" "cluster_block" {
  name = "My-cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.my_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = data.aws_subnets.default_subnets.ids #subnet ids from data block
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster-role_AmazonEKSClusterPolicy, 
  ]
}

# using existing vpc (default)  
data "aws_vpc" "my_vpc" {
  default = true
}
# using default subnets (default)
data "aws_subnets" "default_subnets" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.my_vpc.id] # gettting subnets from default vpc
  }
}

# Role for eks-cluster
resource "aws_iam_role" "my_role" {
  name = "cluster-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}
# arn policy attach to eks-cluster-role
resource "aws_iam_role_policy_attachment" "cluster-role_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.my_role.name
}


# Node-group 
resource "aws_eks_node_group" "node_grp" {
  cluster_name    = aws_eks_cluster.cluster_block.name
  node_group_name = "my-node"
  node_role_arn   = aws_iam_role.my_node_role.arn
  subnet_ids      = data.aws_subnets.default_subnets.ids
  instance_types = [ "m7i-flex.large" ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.role-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Role for node-group
resource "aws_iam_role" "my_node_role" {
  name = "node-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
  })
}

# arn policy attach to node-group role
resource "aws_iam_role_policy_attachment" "role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.my_node_role.name
}
resource "aws_iam_role_policy_attachment" "role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.my_node_role.name
}
resource "aws_iam_role_policy_attachment" "role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.my_node_role.name
}