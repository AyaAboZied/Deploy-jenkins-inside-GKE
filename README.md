# Deploying a Backend Application on a Kubernetes Cluster Using a CI/CD Jenkins Pipeline

## Project Overview
----------------

The purpose of this project is to deploy a backend application on a Kubernetes cluster using a Jenkins CI/CD pipeline. The infrastructure will be created using Terraform on Google Cloud Platform (GCP), and the application will be containerized using Docker.

## Tools Used
----------

The following tools will be used for this project:

-   Terraform
-   GCP
-   Kubernetes
-   Jenkins
-   Docker
-   Shell script

## Getting Started
---------------

To get started with this project, you will need to:

-   Set up a GCP account
-   Install the required tools, such as Terraform and Docker

## Prerequisites
-------------

Before you can begin deploying the application on the Kubernetes cluster, you will need to:

-   Install Terraform
-   Have a GCP account
-   Ensure that the Jenkins master is up and running

## Installation
------------

To install the application on the Kubernetes cluster, follow these steps:

1.  Clone this repository.
2.  Configure your GCP credentials by running `gcloud auth login`.
3.  Run the Terraform files by running `terraform init` followed by `terraform apply`.
4.  SSH into the VM that was created by Terraform and install any necessary software, such as `kubectl` or `gcloud`. You can use Ansible to automate this step.
5. run the script.sh
```bash
vi script.sh
chmod 777 script.sh 
sh script.sh
```
6.  Connect to the GKE private cluster by running `gcloud container clusters get-credentials <cluster_name> --zone <zone> --project <project_id>`.

7.  Copy the provided Kubernetes files and run them by running `kubectl apply -f . `.
8.  To get the IP address of your application, run `kubectl get all`.
9.  Copy the IP address of the load balancer and insert it into your browser to access the application.

## Jenkins Slave Configration
------------

1. exec inside the slave pod and create user
 ```bash
user add jenkins
passwd jenkins
su jenkins
service ssh start
service ssh status
```
2. run the commends inside gcloud-con
3. be sure ssh is ruunnig
4. authenticate gcloud
```bash
gcloud auth login
```
5. configure docker
```bash
gcloud auth configure-docker
chmod 666 /var/run/docker.sock
```
