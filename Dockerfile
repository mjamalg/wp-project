# Use the official Ubuntu slim image as a base
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
    python3-pip \
    vim \
    nano \
    groff \
    git \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip install pyyaml boto3 kubernetes 

#Add Ansible Repo to ensure we get the latest
RUN add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
RUN apt-get update && apt-get install -y ansible && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip && \
    unzip terraform_1.9.5_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.9.5_linux_amd64.zip

# Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin

# Install k9s
RUN cd /tmp && \
    wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb && \
    dpkg -i k9s_linux_amd64.deb && \
    rm k9s_linux_amd64.deb

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install eksctl
RUN curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin

# Install awscli v 2
RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    rm -rf ./aws/
    
# Set default entrypoint
CMD ["/bin/bash"]

