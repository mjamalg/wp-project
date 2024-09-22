# wp-project
This was a project I did for a prospective client to highlight the advantages of EKS over the use of ECS to improve their deployment process. 
I also wanted to demonstrate how Ansible and Terraform could work in tandem to assist with SOC 2 compliance and configuration management.

This project is based on the AWS Whitepaper "Best Practices for WordPress on AWS" which you can download as a PDF here:

https://docs.aws.amazon.com/pdfs/whitepapers/latest/best-practices-wordpress/best-practices-wordpress.pdf#welcome 

Here's the Reference diagram: 

![aws-wp-best-practices](https://github.com/user-attachments/assets/1eea8411-6c1f-4b3e-8ea2-419563ae18f9)

Being me, I decided to tweak the architecture by adding an extra AZ, replacing the EC2 instances with EKS, removing the Bastion Host (we use EC2 Endpoints now!) and adding extra functionality with helm charts like external-dns, AWS Load Balancer Controller, External Secrets Operation for Kubernetes, and Bitnami Wordpress for Kubernetes. 

Additoanl Services Leveraged:
- ACM 
- AWS Secrets Manager 

This is the first of several production ready AWS architectures that I'm publishing to my repo that you can clone and use for your own purposes:
