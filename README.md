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

![wp-project jpg](https://github.com/user-attachments/assets/36069257-cbd3-44fa-b21c-514894f13f9b)

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
            - Change "cert_domain" to your _CERTIFICATE_ domain name.
            - Change "hostname" to whatever you want your wordpress domain to be. It could be your .com or a subdomain. It's your party!
        - templates/bitnami-wp-values.j2:
            - You can change the wordpress admin default username and password in this file.      
    - _roles/eks-addon-config/_
        - files/external-dns-sa-config.yml:
            - Change the "-domain-filter" value to your domain name.
            - Change the Deployment "spec.template.spec.containers.env.name.value" to your desired region
        - defaults/main.yml:
            - Change "cert_manager_helm_chart_version" to the desired version. 1.15.3 was the latest at the time of publishing.
  
##### 3. Provision the AWS architecture (total time betwen 30 - 50 minutes):
##### **VPC**
Run the following commands in the _**vpc-terraform**_ directory:
```
$ terraform init && terraform apply -auto-approve
```
After Terraform is finished provisiong you should have the following resources and services:
- A VPC Resource map that looks similar to this:
  ![wp-project-vpc-readme-1](https://github.com/user-attachments/assets/d72b2194-484c-40d8-a7b7-d063041639cd)
- A List of Security groups that look similar to this:
  ![wp-project-sgr-list-readme-1](https://github.com/user-attachments/assets/fcf2ac29-a697-4043-80ad-1514449ba8fb)
- An Aurora DB cluster using db.t3.medium instances:
  ![wp-project-aurora-readme-1](https://github.com/user-attachments/assets/b8a5b415-03b3-47fa-a330-cd843de2f939)
- An EFS file system and 2 Access points:
  ![wp-project-efs-fs-readme-1](https://github.com/user-attachments/assets/cf4bac5b-1b50-4291-b97d-8358d990692e)
  ![wp-project-efs-ap-readme-1](https://github.com/user-attachments/assets/e7bc7d72-1bb3-4fcf-98ef-3eb328f9d842)
- A 3 node Elasticache/Memcache cluster using cache.t3.micro instances
  ![wp-project-memcached-list-readme-2](https://github.com/user-attachments/assets/92d1fff0-ef12-47b4-bdb9-0a36d91b60a6)
- A secret in Secrets Manager containing the Aurora DB password
  ![wp-project-secrets-mgr-list-readme](https://github.com/user-attachments/assets/9665dfd4-b99c-4d2b-80ee-aeae8fb8f8ef)
- The folowing users creted in IAM:
    - external-secrets with an attached policy called "ESOSecretsManagerPolicy"
    - wpcdn with the AWS managed CloudFrontFullAccess policy attached

##### **EKS**
Run the following commands in the _**eks-ansible**_ directory to deploy EKS:
```
$ ansible-playbook eksctl-config-file-create.yml
```
``` 
$ eksctl create cluster -f eksctl-config-files/eksctl-config.yml
```
After EKS is deployed, verify it's running and that you have access to it by running the following commands:
```
  $ kubectl get nodes
```
![wp-project-kubectl-check-readme-1](https://github.com/user-attachments/assets/2c3e0787-8b26-42ff-acdb-29ca58b916c1)
```
$ kubectl get namespaces
```
![wp-project-kubectl-check-readme-2](https://github.com/user-attachments/assets/cb6fcc25-d954-46d9-ae8c-8f4e813a6a3a)

##### Bitnami WP Install
Run the following command in the _**eks-ansible**_ directory
```
$ ansible-playbook wp-eks-install.yml
```
The playbook has installed the AWS Load Balancer Controller, the External Secrets Operator (allows access to the Secrets Manager secret as a kubernetes secret),  cert-manager, ExternalDNS (synchronizes exposed Kubernetes Services and Ingresses with Route 53) and Bitnami Wordpress for Kubernetes.  There are a few things you should see: 

Route 53
- A TXT entry created by ExternalDNS
- An A record (with and additional CNAME if you specified a subdomain for your hostname) created by ExternalDNS with an alias pointing to an ALB created by the AWS Load Balancer Controllers

ALB
- There will be 2 load balancers created by the AWS Load Balancer Controller based on the ingress rules in the eks-ansible/roles/bitnami-wordpress-install/files/bitnami-wp-values.yml chart. An application load balancer and a network load balancer.

EKS
- There should be a 3 wordpress pods running in the wordpress namespace.
```
$ kubectl get pods -n wordpress
```
![wp-project-bitnami-kubectl-readme-1](https://github.com/user-attachments/assets/26afe757-fc02-49d7-99e0-d94454822dd4)
- After verifying the pods are running check the logs and make sure you see that it's accepting connections
![wp-project-bitnami-readme-2](https://github.com/user-attachments/assets/d08af5cd-40d5-485f-83a5-d4a4dd2e48ab)

 Depending on DNS and your TTL's it may take between 10 minutes and even 2 hours before you'll be able to see the default WP page when you go to your browser:
 ![wp-project-home-page](https://github.com/user-attachments/assets/f323c79c-0ff3-4be8-b424-99eff6e2d669)
A full tutorial on how to use and configure Wordpress is beyond the scope of this project. However I will add a couple of pointers for you to help you get started.
- Wordpress uses the W3 Total Cache plugin for Memcached and CDN configuration. The plugin will not work with AWS Elasticache out of the box. A way forward may be found here:
    - []()[Speeding up WordPress With Amazon ElastiCache for Memcached](https://aws.amazon.com/elasticache/memcached/wordpress-with-memcached)
- Here's a link to an excellent tutorial on how to configure the plugin to work with CloudFront. The wpcdn user has been created for you to do this. The Access Key and Secret Access Key for the user will be located in eks-ansible/roles/bitnami-wordpress-install/files/wpcdn-user-credentials.json provided you ran the wp-eks-install.yml playbook successfully.
    - []()[Setup An AWS CloudFront CDN For WordPress in 15 Minutes](https://www.youtube.com/watch?v=eOOk_wSmfYI)
   
### Removing All Resources
##### 1. Uninstall the Bitnami WordPress helm chart 
This gracefully removes the entry made in the Route 53 host zone by ExternalDNS. If you know anything about DNS you know this comes under **MUST DO!**
```
$ helm uninstall my-release --namespace wordpress
```
##### 2. Use eskctl to delete the EKS cluster (will take between 15 - 30 minutes)
Run the following command in the _**eks-ansible**_ directory:
```
$ eksctl delete cluster -f eksctl-config-files/eksctl-config.yml
```
Feel ree to remove
##### 3. Terraform destory (will take between 15 - 30 minutes)
Run the following command the _**vpc-terraform**_ directory:
```
$ terraform destory -auto-approve
```
## QED
