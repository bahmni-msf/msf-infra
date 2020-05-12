#!/bin/bash
ARTIFACT=`packer build bahmni-packer.json |awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
export PATH=/Users/sreekalyanbapatla/Documents/Terraform/:$PATH
terraform plan -out out.terraform
terraform apply out.terraform

