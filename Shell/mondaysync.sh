#!/bin/bash

CONFIG_FOLDER="/home/centos/trax_mondays_sync/configs"

for config_file in "$CONFIG_FOLDER"/*.yaml; do
  # Extract filename without extension
  config_name=$(basename "$config_file" .yaml)

  # Run command with config name
  /usr/local/bin/python3.9 /home/centos/trax_mondays_sync/trax2monday.py --config "$config_file" 2>&1 >> "/var/log/trax_sync/$config_name.log"
  echo "Exit code: $?" > "/var/log/trax_sync/$config_name-error.log"
  echo "Run Finished $(date)" >> "/var/log/trax_sync/$config_name.log"
  sleep 5s
done