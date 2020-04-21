#!/bin/bash
sudo su -
if [ `whoami` != "root" ]; then echo "Please be a root user to execu^C the script"; fi

#Prerequisite for the fresh installation of Bahmni
 yum install -y https://kojipkgs.fedoraproject.org//packages/zlib/1.2.11/19.fc30/x86_64/zlib-1.2.11-19.fc30.x86_64.rpm >/tmp/installer.log
# Install the bahmni command line program (Choose the version you want).
 yum install  -y https://dl.bintray.com/bahmni/rpm/rpms/bahmni-installer-0.92-147.noarch.rpm >>/tmp/installer.log
# Confirm that the bahmni command is correctly installed (you should see a help message for the command)

bahmni --help  >> /tmp/installation.log
 if [ $? -ne 0 ]
 then
 	echo "Bahmni RPM is not installed" >> /tmp/installation.log
 else
 	echo "Bahmni RPM is installed" >> /tmp/installation.log
fi
# Now setup a configuration file for bahmni command in /etc/bahmni-installer.
curl -L --silent  https://tinyurl.com/y89o5v88 >> /etc/bahmni-installer/setup.yml
# Confirm the contents of the file. It should look like this file: (https://goo.gl/R8ekg5)
echo "******************************************************************"
echo "Below is the setup.yml file" >> /tmp/installation.log
cat /etc/bahmni-installer/setup.yml >> /tmp/installation.log
echo "******************************************************************"
# Set the inventory file name to local in BAHMNI_INVENTORY environment variable. This way you won't need to use the '-i local' switch every time you use the 'bahmni' command
#You can also configure custom inventory file instead of local.
echo "export BAHMNI_INVENTORY=local" >> ~/.bashrc
source ~/.bashrc
bahmni install >/dev/null 2>&1
yum list installed | grep bahmni >>/tmp/installation.log

bahmni -i local backup --backup_type=db --options=openmrs 2>&1

cd /data/openmrs

wget https://databasedumpofbahmni.s3.ap-south-1.amazonaws.com/Openmrs_21_10_2019_encrypted.sql.zip 
unzip Openmrs_21_10_2019_encrypted.sql.zip > /dev/null 2>&1
bahmni -i local restore --restore_type=db --options=openmrs --strategy=dump   --restore_point=Openmrs_21_10_2019_encrypted.sql > /dev/null 2>&1
wget https://github.com/bahmni-msf/amman-config/archive/master.zip > /dev/null 2>&1
unzip master.zip > /dev/null 2>&1
mv amman-config-master bahmni_config
chown -R bahmni:bahmni bahmni_config
