/*########################################################
Main EKS Cluster Permissions

Permissions:
    elasticloadbalancing:DescribeLoadBalancers
    ec2:DescribeSecurityGroups
    ec2:DescribeInstances

Required to create load balancers service for deployments

########################################################*/
resource "aws_iam_policy" "VTC_Service-EKS-ELB-Policy" {
  // EKS cluster permission
  name        = lower("${var.project_name}-VTC_Service-EKS-ELB-Policy")
  description = "Policy to allow EKS to describe ELB resources"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "VTC_Service-EKS-ELB-Policy-Attachment" {
  // Policy Attachment for EKS ELB
  role       = module.VTC-Service-EKS_Cluster.cluster_iam_role_name
  policy_arn = aws_iam_policy.VTC_Service-EKS-ELB-Policy.arn
}
