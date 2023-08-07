#!/bin/bash
# full system backup

# create backup directory
dofbackup=$(date +%Y-%m-%d-%H%M)-fullbackup
mkdir /backup/full/$dofbackup

# rsync in archive mode, preserves all attrubutes, preserves hardlinks
rsync -aAXHv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/backup/full/*","/backup/inc/*","/usr/local/packages/*"} / /backup/full/$dofbackup

# print backup to manifest file
echo "/backup/full/$dofbackup" >> /backup/manifest.txt

#tar and compress backup, then deletes backup
#tar -czf /backups/fullbackups/$dofbackup.tar /backups/fullbackups/$dofbackup
#echo "chill"
#sleep 5
#rm -rf /backups/fullbackups/$dofbackup

