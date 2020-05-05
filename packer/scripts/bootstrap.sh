#!/bin/bash
# A script to intall Bahmni on plane centos

#Cleaning yum cache
yum clean all -q


#Installing zlib as it is a dependancy ( -q is for quite and -y is for input yes )
#Block to validate the rpm installation status
yum list installed  | grep bahmni-installer >/dev/null
    echo "*************************************************************************************************************************" | tee
    echo "Zlib Package  is NOT installed Installing the zlib package............." | tee
    echo "*************************************************************************************************************************"
    yum install https://kojipkgs.fedoraproject.org//packages/zlib/1.2.11/19.fc30/x86_64/zlib-1.2.11-19.fc30.x86_64.rpm -q -y
    echo "*************************************************************************************************************************" | tee
    echo "Zlib package Installation completed" | tee
    echo "*************************************************************************************************************************" | tee
    yum list installed  | grep zlib | tee
    echo "*************************************************************************************************************************" | tee


# Install the bahmni command line program (Choose the version you want).
#check for bahmni rpm inst
yum list installed  | grep bahmni-installer >/dev/null
if [ $? -eq 0 ]; then
    echo "*************************************************************************************************************************" | tee
    echo "bahmni-installer rpm package  is already installed" | tee
    echo "*************************************************************************************************************************" | tee
else
    echo "*************************************************************************************************************************" | tee
    echo "bahmni-installer Package  is NOT installed" | tee
    echo "Installing bahmni-installer RPM..................."
    yum install https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.92-147.noarch.rpm -q -y >/dev/null
    echo "Bahmni-installer Installation completed" | tee
    echo "*************************************************************************************************************************" | tee
fi

# The above setup.yml, has a timezone entry. You can change it to suit your timezone if you like. For valid options
# please read this document: https://bahmni.atlassian.net/wiki/display/BAH/List+Of+Configurable+Installation+Variables
# Now setup a configuration file for bahmni command in /etc/bahmni-installer.
curl -L --silent https://tinyurl.com/yyoj98df >> /etc/bahmni-installer/setup.yml
echo "Below is the bahmni setup file"
echo "*************************************************************************************************************************" | tee
cat /etc/bahmni-installer/setup.yml | tee
echo "*************************************************************************************************************************" | tee

# Set the inventory file name to local in BAHMNI_INVENTORY environment variable. This way you won't need to use the '-i local' switch every time you use the 'bahmni' command
#You can also configure custom inventory file instead of local.
echo "export BAHMNI_INVENTORY=local" >> ~/.bashrc
source ~/.bashrc

echo "*************************************************************************************************************************" | tee
echo "Installing ansible compatible version" | tee
echo "*************************************************************************************************************************" | tee

sudo yum install python-pip python-devel python -y
sudo pip install pip --upgrade
sudo pip install ansible==2.4.2.0

echo "*************************************************************************************************************************" | tee
echo "Installation ansible Completed" | tee
ansible --version | tee
echo "*************************************************************************************************************************" | tee


# Now fire the installer
echo "*************************************************************************************************************************" | tee
echo "Installing Bahmni Modules.................." | tee
echo "*************************************************************************************************************************" | tee
bahmni install
echo "*************************************************************************************************************************" | tee
# Verify installed components using the command:
echo "Bahmni Modules installation completed" | tee
echo "*************************************************************************************************************************" | tee
yum list installed | grep bahmni | tee
echo "*************************************************************************************************************************"  | tee

#Take the backup of openmrs database
echo "*************************************************************************************************************************" | tee
echo "Taking  Backup.................." | tee
echo "*************************************************************************************************************************" | tee

bahmni -i local backup --backup_type=db --options=openmrs > /dev/null 2>&1
backupfiledir="/data/openmrs"
if [ -d $backupfiledir ]; then
  echo "*************************************************************************************************************************" | tee
  echo "Bahmni Backup is successfull"
  else
  echo "*************************************************************************************************************************" | tee
  echo "Bahmni backup failed"
fi

echo "*************************************************************************************************************************" | tee
  echo "Restoring with Vanila database base dump" | tee
echo "*************************************************************************************************************************" | tee
cd $backupfiledir
wget https://bahmnidumps.s3.ap-south-1.amazonaws.com/openmrs_basedump.sql.gz -q
echo "*************************************************************************************************************************" | tee
bahmni -i local restore --restore_type=db --options=openmrs --strategy=dump   --restore_point=openmrs_basedump.sql.gz > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "*************************************************************************************************************************" | tee
  echo "Restore Success..............................."
  echo "*************************************************************************************************************************" | tee
  else
  echo "*************************************************************************************************************************" | tee
  echo "Restore failed check the /tmp/Myrestore.log for more details"
  echo "*************************************************************************************************************************" | tee
fi
