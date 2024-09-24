# WP Project (EKS Version)

## Disclaimer/Notice:
** IF YOU PROVISION THIS ARCHITECTURE THIS WILL COST MONEY!!! THIS WILL TAKE YOU OUT OF THE FREE TIER!!! I'VE TRIED MY BEST TO KEEP COSTS LOW BY USING THE SMALLEST INSTANCE CLASSES ALLOWED AND THE CHEAPEST CONFIGURATIONS. HOWEVER THERE WILL STILL BE COSTS ASSOCIATED. YOU'VE BEEN WARNED!!!!! **

### About
This was a project I did for a prospective client to highlight the advantages of AWS EKS over the use of ECS to improve their deployment process. I also wanted to demonstrate how Ansible and Terraform could work in tandem for provisiong, configuation management, and security compliance. Most of all, I wanted to do all of this with as close to a "Production" level architecture as I could provision without spending the few coins I have AND the provisioning had to be automated.

The project is based on the AWS Whitepaper "Best Practices for WordPress on AWS" which you can download as a PDF here:

AWS Whitepaper: Best Practices for WordPress

[https://docs.aws.amazon.com/pdfs/whitepapers/latest/best-practices-wordpress/best-practices-wordpress.pdf#welcome]()

Here's the original reference diagram from the whitepaper:

![aws-presentation](https://github.com/user-attachments/assets/a4aac926-36ca-47a2-b578-1eb87f485214)

I decided to modify the whitepaper architecture by adding an extra AZ, replacing EC2 instances with an EKS cluster, removing the Bastion Host (LOL) and adding extra functionality with helm charts for external-dns, the AWS Load Balancer Controller, the External Secrets Operator for Kubernetes, and Bitnami's Wordpress for Kubernetes. Here's my version:

Additional services leveraged not included in the whitepaper:
* AWS Certificate Manager (ACM)
* AWS Secrets Manager (AWSSM)

### Prerequisites
- Intermediate level knowledge of: 
    - AWS (especially IAM Roles for Service Accounts (IRSA))
    - Kubernetes
- Novice level experience working with Wordpress.
    
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
        - Change to your desired region  
        - Add your preferred AWS authentication information to the AWS provider definition.
- **In eks-ansible**
    - _roles/bitnami-wordpress-install/_
        - defaults/main.yml:
            - Change "cert_domain" to your domain name.
            - Change "hostname" to your domain name.
    - _roles/eks-addon-config/_
        - files/external-dns-sa-config.yml:
            - Change the "-domain-filter" value to your domain name.
            - Change the Deployment "spec.template.spec.containers.env.name.value" to your desired region
        - defaults/main.yml:
            - Change "cert_manager_helm_chart_version" to the desired version. 1.15.3 was the latest at the time of publishing.
  
##### 3. Provision the AWS architecture (total time betwen 30 - 50 minutes):
###### VPC
Run the following commands in the _**vpc-terraform**_ directory:
```
$ terraform init && terraform apply -auto-approve
```
After Terraform is finished provisiong you should have the following resources and services:
- A VPC Resource map that looks similar to this:
  ![wp-project-vpc-readme-1](https://github.com/user-attachments/assets/d72b2194-484c-40d8-a7b7-d063041639cd)

- A List of Security groups that look similar to this:
- An Aurora DB cluster using db.t3.medium instances:
- An EFS file system with a 2 Access points:
- A 3 node Elasticache/Memcache cluster using cache.t3.micro instances
- A secret in Secrets Manager containing the Aurora DB password
- The folowing users creted in IAM:
    - external-secrets with an attached policy called "ESOSecretsManagerPolicy"
    - wpcdn with the AWS managed CloudFrontFullAccess policy attached

###### EKS
Run the following commands in the _**eks-ansible**_ directory to deploy EKS:
    * ```$ ansible-playbook eksctl-config-file-create.yml
    ```
     * ``` $ eksctl create cluster -f eksctl-config-files/eksctl-config.yml
    ```

After EKS is deployed, verify it's running and that you have access to it by running the following commands:
    * ``` $ kubectl get nodes
    ```
(pic goes here)
    * ``` $ kubectl get namespaces
    ```
(pic goes here)
    
##### Bitnami WP Install
Run the following command in the _**eks-ansible**_ directory
    * ```$ ansible-playbook wp-eks-install.yml
    ```

The playbook has installed the AWS Load Balancer Controller, the External Secrets Operator (allows access to the Secrets Manager secret as a kubernetes secret),  cert-manager, ExternalDNS (synchronizes exposed Kubernetes Services and Ingresses with Route 53)
 and Bitnami Wordpress for Kubernetes.  Depending on DNS and TTL's it may take between 10 minutes and even 2 hours before you'll be able to see 
 






