#!/bin/sh
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
echo "This is for configuration"
# Switch to config directory
cd /etc/bahmni-installer/deployment-artifacts
# Get the desired config
wget https://github.com/Bahmni/default-config/archive/master.zip -q && unzip master.zip >/dev/null && mv default-config-master myhospital_config && rm -f master.zip>/dev/null
curl -L --silent https://raw.githubusercontent.com/bahmni-msf/Bahmni-SetupFiles/master/setup.yml >  /etc/bahmni-installer/setup.yml
echo "Below is the bahmni setup file"
echo "*************************************************************************************************************************"
echo "*************************************************************************************************************************"
#Take the backup of openmrs database
echo "*************************************************************************************************************************"
echo "Taking  Backup.................."
echo "*************************************************************************************************************************"
curl -L --silent https://raw.githubusercontent.com/bahmni-msf/Bahmni-SetupFiles/master/local > /etc/bahmni-installer/inventory

# Set the inventory file name to inventory in BAHMNI_INVENTORY environment variable. This way you won't need to use the '-i inventory' switch every time you use the 'bahmni' command
#You can also configure custom inventory file instead of local.
echo "export BAHMNI_INVENTORY=inventory" >> ~/.bashrc
source ~/.bashrc
bahmni  backup --backup_type=db --options=openmrs > /dev/null 2>&1
backupfiledir="/data/openmrs"
if [ -d $backupfiledir ]; then
  echo "*************************************************************************************************************************"
  echo "Bahmni Backup is successfull"
  else
  echo "*************************************************************************************************************************"
  echo "Bahmni backup failed"
fi
echo "*************************************************************************************************************************"
echo "Remove openmrs, bahmni-emr, bahmni-web modules."
yum remove openmrs bahmni-emr bahmni-web -y -q
echo "*******************************************************************s******************************************************"
echo "openmrs, bahmni-emr, bahmni-web modules removed"
echo "*************************************************************************************************************************"
echo "Drop existing openmrs database."
mysql -uroot -pP@ssw0rd -e "drop database openmrs"
echo "*************************************************************************************************************************"

# Now fire the installer
echo "*************************************************************************************************************************"
echo "Installing Bahmni Modules.................."
echo "*************************************************************************************************************************"
bahmni install > /dev/null 2>&1
echo "*************************************************************************************************************************"
## Verify installed components using the command:
curl -L --silent https://raw.githubusercontent.com/bahmni-msf/Bahmni-SetupFiles/master/mysqldump.sql > /tmp/Metadataone.sql
mysql -uroot -pP@ssw0rd openmrs </tmp/Metadataone.sql
echo "*************************************************************************************************************************"
echo "Restarting Openmrs"
systemctl restart openmrs
echo "*************************************************************************************************************************"
