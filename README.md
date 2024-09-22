# wp-project
Using Terraform and Ansible to provision the AWS Wordpress Refefence architecture replacing EC2 instances with EKS,
and adding extra goodies like external-dns, AWS Load Balancer Controller, External Secrets Operation for Kubernetes,
and Bitnami Wordpress for Kubernetes. 

AWS Services Leveraged:
- VPC
- Nat GW
- IGW
- EKS
- EFS
- ACM
- AWS Secrets Manager
- Elasticache/Memcached
- Aurora DB

Other Kubernetes applications:
- External Secrets Operator
- External-DNS
- AWS Load Balancer Controller
- Bitnami Wordpress Installation
