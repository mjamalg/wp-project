# WP Project (EKS Version)

## Disclaimer/Notice:
** IF YOU PROVISION THIS ARCHITECTURE THIS WILL COST MONEY!!! THIS WILL TAKE YOU OUT OF THE FREE TIER!!! I'VE TRIED MY BEST TO KEEP COSTS LOW BY USING THE SMALLEST INSTANCE CLASSES ALLOWED AND THE CHEAPEST CONFIGURATIONS. HOWEVER THERE WILL STILL BE COSTS ASSOCIATED. YOU'VE BEEN WARNED!!!!! **

### About
This was a project I did for a prospective client to highlight the advantages of AWS EKS over the use of ECS to improve their deployment process. I also wanted to demonstrate how Ansible and Terraform could work in tandem for provisiong, configuation management, and security compliance, and I wanted to do all of this with as close to a "Production" level architecture as I could provision without spending the few coins I had.

The project is based on the AWS Whitepaper "Best Practices for WordPress on AWS" which you can download as a PDF here:

AWS Whitepaper: Best Practices for WordPress

[https://docs.aws.amazon.com/pdfs/whitepapers/latest/best-practices-wordpress/best-practices-wordpress.pdf#welcome]()

Here's the original reference diagram in the whitepaper:

![aws-presentation](https://github.com/user-attachments/assets/a4aac926-36ca-47a2-b578-1eb87f485214)

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
* pip and the following python libraries:
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
Feel free to use my Ubuntu based image that contains all the packages and libraries needed. 
```
$ docker run -it mjsmoov97/wp-project-runenv:latest 
```
### How To Provision 
##### 1. Clone the Repo
```
$ git clone git@github.com:mjamalg/wp-project.git
```
##### 2.  Update the following files:
- **In vpc-terraform**
    - _providers.tf:_
        - Change to your desired Region  
        - Add your preferred AWS Authentication information to the AWS provider definition.
- **In eks-ansible**
    - _roles/bitnami-wordpress-install/defaults/main.yml:_
        - Change "cert_domain" to your domain name.
        - Change "hostname" to your domain name.
    - _roles/eks-addon-config/files/external-dns-sa-config.yml:_
        - Change the "--domain-filter" value to your domain name.
  
##### 3. Provision the AWS environment (total time betwen 25 - 45 minutes):
###### VPC (Provision time approx 20 - 35 minutes)
- Run the following commands in the _vpc-terraform_ directory:
    - ```
      $ terraform init && terraform apply -auto-approve
    ```
- Terraform provisions the following:
    - A new VPC tagged "WP Project" consisting of:
        - 3 Availablity Zones - us-east-1a,1b,1c with each az consisting of 1 public and 2 private subnets.
            - Public subnets are tagged WP Project-pub-1a|1b|1c.
            - Private app subnets (where the EKS cluster will be created) are tagged WP Project-priv-app-1a|1b|1c.
            - Private data subnets (where Aurora, Memcache and EFS are created) are tagged with WP Project-priv-data-1a|1b|1c.
    - 1 IGW tagged "WP Project Public IGW" where all public subnets are routed through.
    - 3 NAT GW's tagged "WP Project Priv NATGW", one for each AZ
    - 5 route tables:
        - Default route table for the VPC
        - 1 public route table tagged WP Project Public Rtb
        - 3 private route tables tagged WP Project Private Rtb
        - 5 Security Groups:  
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









