# MSF Infrastructure Automation
This repository is for the automation of various MSF infrastructures such as QA, UAT, PreProd etc.

For this automation, we used 2 open-source tools - packer and terraform.

### Packer
[Packer](https://packer.io/) is used for building the images for bahmni installer.

Packer configuration file includes three blocks, one for defining the variables and the builders block include the AWS specific configuration details. In provisioners block we are using a shell script to invoke bootstrap.sh script which will take care of bahmni installation.

With the help of packer we are able to create Amazon Machine Image which include bahmni latest version 0.92 on centOS 7.6.
The advantage of packer is, if in case there is an additional software that is required to be imbibed in the Image or any additional software, dependant software need to be installed we could specify that in the bootsrap.sh file.

<b>Creating Image Procedure</b>:-

1. Clone the required files <b>"bahmni-packer.json" </b> and <b>"vars.json" </b>. 
2. Update the access key and secret key in the <b>"vars.json" </b>.
3. Copy the Scripts directory which includes the <b>bootsrap.sh </b> script.
4. Run command <b> "packer validate bahmni-packer.json" </b> to validate the packer file.
5. Run command <b> "packer inspect bahmni-packer.json" </b> to check the specifications with which the image is going to get created.
6. Run command <b> "packer build -var-file=vars.json bahmni-packer.json" </b> to build the image.
7. Check respective AWS account if the Screenshot and AMI is created or not.

### Terraform
[Terraform](https://www.terraform.io/) is used to create, manage, and update various relevant AWS infrastructure resources (such as EC2, S3, Route53 etc.) for the different environments.
