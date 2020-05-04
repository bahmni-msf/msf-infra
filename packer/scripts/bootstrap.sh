#!/bin/bash
# A script to intall Bahmni on plane centos

#Cleaning yum cache
yum clean all -q

#Create a log file
file="/tmp/installation.log"
if [ -f $file ]
then
  mv $file $file.backup.$(date +%F_%R).logs
  touch $file
else
  touch $file
fi
#Installing zlib as it is a dependancy ( -q is for quite and -y is for input yes )
#Block to validate the rpm installation status
yum list installed  | grep bahmni-installer >/dev/null
    echo "*************************************************************************************************************************" | tee -a $file
    echo "Installing the zlib package............." | tee -a $file
    echo "*************************************************************************************************************************"
    yum install https://kojipkgs.fedoraproject.org//packages/zlib/1.2.11/19.fc30/x86_64/zlib-1.2.11-19.fc30.x86_64.rpm -q -y
    echo "*************************************************************************************************************************" | tee -a $file
    echo "Zlib package Installation completed" | tee -a $file
    echo "*************************************************************************************************************************" | tee -a $file
    yum list installed  | grep zlib | tee -a $file
    echo "*************************************************************************************************************************" | tee -a $file


# Install the bahmni command line program (Choose the version you want).
#check for bahmni rpm inst
yum list installed  | grep bahmni-installer >/dev/null
if [ $? -eq 0 ]; then
    echo "*************************************************************************************************************************" | tee -a $file
    echo "bahmni-installer rpm package  is already installed" | tee -a $file
    echo "*************************************************************************************************************************" | tee -a $file
else
    echo "*************************************************************************************************************************" | tee -a $file
    echo "bahmni-installer Package  is NOT installed" | tee -a $file
    echo "Installing bahmni-installer RPM..................."
    yum install https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.92-147.noarch.rpm -q -y >/dev/null
    echo "Bahmni-installer Installation completed" | tee -a $file
    echo "*************************************************************************************************************************" | tee -a $file
fi

# The above setup.yml, has a timezone entry. You can change it to suit your timezone if you like. For valid options
# please read this document: https://bahmni.atlassian.net/wiki/display/BAH/List+Of+Configurable+Installation+Variables
# Now setup a configuration file for bahmni command in /etc/bahmni-installer.
curl -L --silent https://tinyurl.com/yyoj98df >> /etc/bahmni-installer/setup.yml
echo "Below is the bahmni setup file"
echo "*************************************************************************************************************************" | tee -a $file
cat /etc/bahmni-installer/setup.yml | tee -a $file
echo "*************************************************************************************************************************" | tee -a $file

# Set the inventory file name to local in BAHMNI_INVENTORY environment variable. This way you won't need to use the '-i local' switch every time you use the 'bahmni' command
#You can also configure custom inventory file instead of local.
echo "export BAHMNI_INVENTORY=local" >> ~/.bashrc
source ~/.bashrc

echo "*************************************************************************************************************************" | tee -a $file
echo "Installing ansible compatible version" | tee -a $file
echo "*************************************************************************************************************************" | tee -a $file

sudo yum install python-pip python-devel python -y  > /dev/null 2>&1
sudo pip install pip --upgrade > /dev/null 2>&1
sudo pip install ansible==2.4.2.0 > /dev/null 2>&1

echo "*************************************************************************************************************************" | tee -a $file
echo "Installation ansible Completed" | tee -a $file
ansible --version | tee -a $file
echo "*************************************************************************************************************************" | tee -a $file


# Now fire the installer
echo "*************************************************************************************************************************" | tee -a $file
echo "Installing Bahmni Modules.................." | tee -a $file
echo "*************************************************************************************************************************" | tee -a $file
bahmni install > /dev/null 2>&1
echo "*************************************************************************************************************************" | tee -a $file
# Verify installed components using the command:
echo "Bahmni Modules installation completed" | tee -a $file
echo "*************************************************************************************************************************" | tee -a $file
yum list installed | grep bahmni | tee -a $file
echo "*************************************************************************************************************************"  | tee -a $file

#Take the backup of openmrs database
echo "*************************************************************************************************************************" | tee -a $file
echo "Taking  Backup.................." | tee -a $file
echo "*************************************************************************************************************************" | tee -a $file

bahmni -i local backup --backup_type=db --options=openmrs > /dev/null 2>&1
backupfiledir="/data/openmrs"
if [ -d $backupfiledir ]; then
  echo "*************************************************************************************************************************" | tee -a $file
  echo "Bahmni Backup is successfull"
  else
  echo "*************************************************************************************************************************" | tee -a $file
  echo "Bahmni backup failed"
fi

echo "*************************************************************************************************************************" | tee -a $file
  echo "Restoring with Vanila database base dump" | tee -a $file
echo "*************************************************************************************************************************" | tee -a $file
cd $backupfiledir
wget https://bahmnidumps.s3.ap-south-1.amazonaws.com/openmrs_basedump.sql.gz -q
echo "*************************************************************************************************************************" | tee -a $file
bahmni -i local restore --restore_type=db --options=openmrs --strategy=dump   --restore_point=openmrs_basedump.sql.gz > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "*************************************************************************************************************************" | tee -a $file
  echo "Restore Success..............................."
  echo "*************************************************************************************************************************" | tee -a $file
  else
  echo "*************************************************************************************************************************" | tee -a $file
  echo "Restore failed check the /tmp/Myrestore.log for more details"
  echo "*************************************************************************************************************************" | tee -a $file
fi
