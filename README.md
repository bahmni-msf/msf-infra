# MSF Infrastructure Automation
This repository is for the automation of various MSF infrastructures such as QA, UAT, PreProd etc.

For this automation, we used 2 open-source tools - packer and terraform.

### Packer
[Packer](https://packer.io/) is used for building the images for bahmni installer.

Packer configuration file includes three blocks, one for defining the variables and the builders block include the AWS specific configuration details. In provisioners block we are using a shell script to invoke bootstrap.sh script which will take care of bahmni installation.

With the help of packer we are able to create Amazon Machine Image which include bahmni latest version 0.92 on centOS 7.6.
The advantage of packer is, if in case there is an additional software that is required to be imbibed in the Image or any additional software, dependant software need to be installed we could specify that in the bootsrap.sh file.

#### Creating Image Procedure

```
# 1. Clone the msf-infra reposiroty
$ git clone git@github.com:bahmni-msf/msf-infra.git
$ cd msf-infra/packer

# 2. Update the AWS access key and secret key in the `image.json`  file.

# 3. Validate the packer file
$ packer inspect image.json

# 4. Check the specifications with which the image is going to get created
$ packer inspect image.json

# 5. Build the image (AMI)
$ packer build image.json

# 6. Check respective AWS account if the AMI is created or not.
```

### Terraform
[Terraform](https://www.terraform.io/) is used to create, manage, and update various relevant AWS infrastructure resources (such as EC2, S3, Route53 etc.) for the different environments.

There are three files defined in the terraform directory, the main intention of terraform config files are to provision new EC2 instances with default VPC and default Security group. The terraform helps us to retain the state of the instance even if there is any manual change done through console. The time which we spend up on spinning up the instances also brought down with help of </b> Terraform </b>

#### Installation Steps
Install Terraform in your local machine.(Ref: [link](https://learn.hashicorp.com/terraform/getting-started/install.html))
```
$ brew install terraform
```
#### Folder Structure
Terraform directory which consists of 3 files:

 `instance.tf` -  includes variable declaration, provider information, resource provisioning configuration.

 `bahmni_initial_setup_script.sh`  - Includes all the dependant/desired application setup in the instance.

 `terraform.tfvars` -  This is the file where we would include the variable values that will get passed as parameters.

#### Steps to run Terraform config

```
# 1. Clone the repository
$ git clone git@github.com:bahmni-msf/msf-infra.git
$ cd msf-infra/terraform

# 2. Update the values in the `terraform.tfvars`  file with corresponding AWS access key, secret key and desired region, AMI we could use the AMI that we have created through packer instance.

# 3. The important parameter in the `terraform.tfvars` file is the key pair, we need to choose a key pair that we want to associate with newly spinning up instance. we need to get the .pem extension file in to local machine from where the config is running and update as below example.

KEY_NAME = "standard" ( No need to mention path and pem extension )

PATH_TO_PRIVATE_KEY= "/Users/*****/Documents/Terraform/test/standard.pem" ( Need to mention path and pem extension )

# 4. Plan the terraform file
$ terraform plan

# 5. Apply the terraform file
$ terraform apply  
```       
       
