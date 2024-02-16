Quick explainers for the desired function of each script:

- fusion_backup_apps.sh was created to perform a weekly backup of our search applications for each of our clients, then store said changes in an SVN repository to allow for change control on any modifications made throughout the week
- import_le_cert_jks.sh takes the cert info from acme.sh (lets encrypt shell client) and converts it into a useable format for Java Key Store and handles the import into the keystore
- mondaysync.sh looks for any YAML files in the defined config path and loops through each while logging any errors that might occur. A nagios check monitors the $config_name-error.log file for any non 0 exit codes and throws an alert if any are found
- lightsail-recovery.sh is a nagios event handle script that performs a reboot on the instance in the event the http head check to the site fails, if it is unable to resolve it then throws a hard critical and triggers our call alert system
