#!/bin/bash
# A script to intall Bahmni on plane centos
#Cleaning yum cache
yum clean all -q
#Installing zlib as it is a dependancy ( -q is for quite and -y is for input yes ) Block to validate the rpm installation status
    echo "*************************************************************************************************************************" 
    echo "Installing the latest version of zlib............." 
    echo "*************************************************************************************************************************"
    yum install https://kojipkgs.fedoraproject.org//packages/zlib/1.2.11/19.fc30/x86_64/zlib-1.2.11-19.fc30.x86_64.rpm -q -y
    echo "*************************************************************************************************************************" 
    echo "Zlib package Installation completed" 
    echo "*************************************************************************************************************************" 
    yum list installed  | grep zlib 
    echo "*************************************************************************************************************************" 
# Install the bahmni command line program (Choose the version you want). check for bahmni rpm inst
yum list installed  | grep bahmni-installer >/dev/null
if [ $? -eq 0 ]; then
    echo "*************************************************************************************************************************" 
    echo "bahmni-installer rpm package  is already installed" 
    echo "*************************************************************************************************************************" 
else
    echo "*************************************************************************************************************************" 
    echo "bahmni-installer Package  is NOT installed" 
    echo "Installing bahmni-installer RPM..................."
    yum install https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.92-147.noarch.rpm -q -y >/dev/null
    echo "Bahmni-installer Installation completed" 
    yum list installed | grep bahmni-installer
    echo "*************************************************************************************************************************" 
fi
# The above setup.yml, has a timezone entry. You can change it to suit your timezone if you like. For valid options
# please read this document: https://bahmni.atlassian.net/wiki/display/BAH/List+Of+Configurable+Installation+Variables
# Now setup a configuration file for bahmni command in /etc/bahmni-installer.
curl -L --silent https://tinyurl.com/yyoj98df >> /etc/bahmni-installer/setup.yml
echo "Below is the bahmni setup file"
echo "*************************************************************************************************************************"
cat /etc/bahmni-installer/setup.yml
echo "*************************************************************************************************************************"
# Set the inventory file name to inventory in BAHMNI_INVENTORY environment variable. This way you won't need to use the '-i inventory' switch every time you use the 'bahmni' command
#You can also configure custom inventory file instead of local.
echo "export BAHMNI_INVENTORY=local" >> ~/.bashrc
source ~/.bashrc
echo "*************************************************************************************************************************" 
echo "Installing ansible compatible version" 
echo "*************************************************************************************************************************" 
sudo yum install python-pip python-devel python -y > /dev/null 2>&1
sudo pip install pip --upgrade > /dev/null 2>&1
sudo pip install ansible==2.4.2.0 > /dev/null 2>&1
echo "*************************************************************************************************************************" 
echo "Installation ansible Completed" 
ansible --version 
echo "*************************************************************************************************************************" 
# Now fire the installer
echo "*************************************************************************************************************************" 
echo "Installing Bahmni Modules.................." 
echo "*************************************************************************************************************************" 
bahmni install > /dev/null 2>&1
echo "*************************************************************************************************************************" 
# Verify installed components using the command:
echo "Bahmni Modules installation completed" 
echo "*************************************************************************************************************************" 
yum list installed | grep bahmni 
echo "*************************************************************************************************************************"  
