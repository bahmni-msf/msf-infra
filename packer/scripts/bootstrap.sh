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
    sudo yum install epel-release >/dev/null
    sudo yum install python-pip >/dev/null
    sudo pip install pip==v19.0 >/dev/null
    sudo pip uninstall click >/dev/null
    sudo pip install click==v7.0 >/dev/null
    sudo pip install pyusb >/dev/null
    sudo pip install babel==v0.9.6 >/dev/null
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
    yum install http://repo.mybahmni.org/releases/bahmni-installer-0.92-155.noarch.rpm -q -y >/dev/null
    echo "Bahmni-installer Installation completed"
    yum list installed | grep bahmni-installer
    echo "*************************************************************************************************************************"
fi
# The above setup.yml, has a timezone entry. You can change it to suit your timezone if you like. For valid options
# please read this document: https://bahmni.atlassian.net/wiki/display/BAH/List+Of+Configurable+Installation+Variables
# Now setup a configuration file for bahmni command in /etc/bahmni-installer.
curl -L --silent https://tinyurl.com/yyoj98df >> /etc/bahmni-installer/setup.yml
echo "\nbahmni_repo_url: http://repo.mybahmni.org/releases/" >> /etc/bahmni-installer/setup.yml
echo "\nmysql_version: 5.6.48" >> /etc/bahmni-installer/setup.yml
echo "Below is the bahmni setup file"
echo "*************************************************************************************************************************"
cat /etc/bahmni-installer/setup.yml
echo "*************************************************************************************************************************"
# Set the inventory file name to inventory in BAHMNI_INVENTORY environment variable. This way you won't need to use the '-i inventory' switch every time you use the 'bahmni' command
#You can also configure custom inventory file instead of local.
rm -rf /etc/bahmni-installer/local
curl -L --silent https://tinyurl.com/4svdbjnx >> /etc/bahmni-installer/local
echo "export BAHMNI_INVENTORY=local" >> ~/.bashrc
source ~/.bashrc
echo "*************************************************************************************************************************"
echo "Installing ansible compatible version"
echo "*************************************************************************************************************************"
echo "*************************************************************************************************************************"
echo "Installation ansible Completed"
ansible --version
echo "*************************************************************************************************************************"
# Now fire the installer
echo "*************************************************************************************************************************"
echo "Installing Bahmni Modules.................."
echo "*************************************************************************************************************************"
bahmni -aru http://repo.mybahmni.org/releases/ansible-2.4.6.0-1.el7.ans.noarch.rpm install > /dev/null 2>&1
echo "*************************************************************************************************************************"
# Verify installed components using the command:
echo "Bahmni Modules installation completed"
echo "*************************************************************************************************************************"
yum list installed | grep bahmni
echo "*************************************************************************************************************************"
