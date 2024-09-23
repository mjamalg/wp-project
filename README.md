# WP Project

## Disclaimer/Notice:
** IF YOU PROVISION THIS ARCHITECTURE THIS WILL COST MONEY!!! THIS WILL TAKE YOU OUT OF THE FREE TIER!!! I'VE TRIED MY BEST TO KEEP COSTS LOW BY USING THE SMALLEST INSTANCE CLASSES ALLOWED AND THE CHEAPEST CONFIGURATIONS. HOWEVER THERE WILL STILL BE COSTS ASSOCIATED. YOU'VE BEEN WARNED!!!!! **

### About
This was a project I did for a prospective client to highlight the advantages of AWS EKS over the use of ECS to improve their deployment process. I also wanted to demonstrate how Ansible and Terraform could work in tandem for provisiong, configuation management, and security compliance, and I wanted to do all of this with as close to a "Production" level architecture as I could provision without spending the few coins I had.

The project is based on the AWS Whitepaper "Best Practices for WordPress on AWS" which you can download as a PDF here:

AWS Whitepaper: Best Practices for WordPress

[https://docs.aws.amazon.com/pdfs/whitepapers/latest/best-practices-wordpress/best-practices-wordpress.pdf#welcome]()

Here's the original reference diagram in the whitepaper:

![AWS Reference Architecture](/home/jamal/Downloads/aws-presentation.jpg)

Being me, I decided to tweak the architecture by adding an extra AZ, replacing the EC2 instances with EKS, removing the Bastion Host (we use EC2 Endpoints now!) and adding extra functionality with helm charts like external-dns, AWS Load Balancer Controller, External Secrets Operator for Kubernetes, and Bitnami Wordpress for Kubernetes.

Additional services leveraged not included in the whitepaper:
* AWS Certificate Manager (ACM)
* AWS Secrets Manager (AWSSM)

### Prerequisites
Intermediate level knowledge of: 
    * AWS
    * Kubernetes
Novice level experience working with Wordpress.
    
##### **AWS:**
* Administror level access to an AWS account and a user that has permissions to provision all services in AWS. Whatever user you use for Terraform should be sufficient.
* A domain in Route 53 that you control with a public zone.
* A FREE certificate created with the ACM for your domain (It's FREE).

##### **System:**
* Python ≥ 3.10  
* pip (latest) and the following python libraries:
    * boto3
    * pyyaml
    * kubernetes
* ansible-core ≥  2.17
* terraform ≥ 1.9.3
* helm ≥ 3.16.1
* eksctl ≥ 0.189.0
* awscli ≥ v2
* kubectl ≥ 1.30.5
* k9s  ≥ 0.30.4 (optional: only you have experience using it to manage Kubernetes clusters)

##### **System Alternative:**
Feel free to use my Ubuntu based image that contains all the above packages. 
```bash
docker run -it mjsmoov97/wp-project-runenv:latest 
```
### How To Provision 
Clone the repo
##### make changes in the following files:
- **vpc-terraform/providers.tf:** Add your preferred AWS Authentication information to the AWS provider definition, as well as your state file backend defintion if you're using a specific backend for the terraform state file.
- **eks-ansible/roles/bitnami-wordpress-install/files/defaults/main.yml:**  Change "cert_domain" and "hostname" to your domain name.
- **eks-ansible/roles/eks-addon-config/external-dns-sa-config.yml:** change the --domain-filter value to your domain name.n

##### Provision the AWS environment (total time betwen 25 - 45 minutes):
- VPC
* Run the following commands:
    * ```
        $ cd vpc-terraform
        $ terraform init
        $ terraform plan
        $ terraform apply -auto-approve
	```
- EKS Cluster
    * run the following commands:
        * ```
          $ cd eks-ansible 
            ```
        * ```
          $ ansible-playbook eksctl-config-file-create.yml
          ```
        * ```
          $ eksctl create cluster -f eksctl-config-files/eksctl-config.yml
            ```
    Verify K8s









