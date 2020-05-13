# Variable Declaration
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}
variable "AMI" {}
variable "INSTANCE_TYPE" {}
variable "KEY_NAME" {}
variable "INSTANCE_NAME" {}
variable "PATH_TO_PRIVATE_KEY" {}
variable "DEFAULT_USER" {}

#Provider Information
provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
}

#Instance Setup
resource "aws_instance" "Bahmni_Implementation_QA" {
    ami =   var.AMI
    instance_type = var.INSTANCE_TYPE
    key_name = var.KEY_NAME
    tags = {
      Name = var.INSTANCE_NAME
    }
}
#Create and assibn elastic IP
resource "aws_eip" "myeip" {
  instance = aws_instance.Bahmni_Implementation_QA.id
}
# File provisioning to install bahmni dependancies
resource "null_resource" "ec2-ssh-connection" {
    connection {
          host        = aws_eip.myeip.public_ip
          type        = "ssh"
          port        = 22
          user        = var.DEFAULT_USER
          private_key = file(var.PATH_TO_PRIVATE_KEY)
          timeout     = "1m"
          agent       = false
        }
    provisioner "file" {
        source      = "bahmni_initial_setup_script.sh"
        destination = "/tmp/bahmni_initial_setup_script.sh"
      }
    provisioner "remote-exec" {
          inline = [
            "chmod +x /tmp/bahmni_initial_setup_script.sh",
            "sudo sed -i -e 's/\r$//' /tmp/bahmni_initial_setup_script.sh",
            # Remove the spurious CR characters.
            "sudo /tmp/bahmni_initial_setup_script.sh",
       ]
      }
}


output "PrivateIPaddress" {
  value = aws_instance.Bahmni_Implementation_QA.private_ip
}
output "Elasticip" {
  value = aws_eip.myeip.public_ip
}

terraform {
  required_version = ">= 0.12"
}