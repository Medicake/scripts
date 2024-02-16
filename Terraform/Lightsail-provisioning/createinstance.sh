#!/bin/bash

#Creating Instance yaml file
export client=$(<clientname.txt)
rm -f ./wordpress-scripts/createinstance-final.yaml ./wordpress-scripts/temp-instance.yaml
( echo "cat <<EOF >./wordpress-scripts/createinstance-final.yaml";
  cat ./wordpress-scripts/createinstance-template.yaml;
  echo "EOF";
) >./wordpress-scripts/temp-instance.yaml
. ./wordpress-scripts/temp-instance.yaml

#Creating CPU Alarm for instance
export client=$(<clientname.txt)
rm -f ./wordpress-scripts/createalarm-final.yaml ./wordpress-scripts/temp-alarm.yaml
( echo "cat <<EOF >./wordpress-scripts/createalarm-final.yaml";
  cat ./wordpress-scripts/createalarm-template.yaml;
  echo "EOF";
) >./wordpress-scripts/temp-alarm.yaml
. ./wordpress-scripts/temp-alarm.yaml



#Executing files
aws lightsail create-instances-from-snapshot --cli-input-yaml file://./wordpress-scripts/createinstance-final.yaml > output.log
#sleep to wait for the instance to spin up
sleep 200
aws lightsail put-alarm --cli-input-yaml file://./wordpress-scripts/createalarm-final.yaml >> output.log
