#!/bin/bash

configdir=/opt/Fusion_5
backupdir=/opt/Fusion_5/Backups
date=$(date)

#building list of app ids for export
curl -u fusion-service-account:supersecurepassword https://searchserver.domain.com:6764/api/apps | jq -r '.[].id' > ${configdir}/apps.config

for fusionapp in  $(cat ${configdir}/apps.config)
do
  # exporting apps to $appname.zip
  curl -u fusion-service-account:supersecurepassword https://searchserver.domain.com:6764/api/objects/export?app.ids=${fusionapp} > ${configdir}/${fusionapp}.zip
  echo "Exit code: $?" > /var/log/fusion/${fusionapp}-export-error.log
  unzip -o ${configdir}/${fusionapp}.zip -d ${backupdir}/${fusionapp}
done

svn add --username fusion_svn ${backupdir}/*
svn ci ${backupdir} --username fusion_svn -m 'backing up fusion apps'