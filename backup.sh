#!/bin/bash
#rsync backup
# Diego Orozco

# declare variables
backupdir=/backup 				# root backup directory
dofbackup=$(date +%Y-%m-%d-%H%M)-fullbackup 	# directory name for full backups
doibackup=$(date +%Y-%m-%d-%H%M)-incbackup 	# directorty name for inceremental backups
pathtoman=$backupdir/manifest.txt 		# output to manifest
today=$(date +%u) 				# numerical copnversion of todays date
day=7						# numerical conversion of day you want full backup to run Mon=1 Tue=2 Wed=3 etc...
secmax=604800					# max days since last fullbackup in seconds, this will used to proritize full backups even if $today =! $fday
exclusions="/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/backup/full/*","/backup/inc/*","/usr/local/packages/*" # directories to exclude from backup **** make sure to exclude backup directory
lastfull=$(tail -n -1 $pathtoman) # manifest containing all full backups

if [ "$today" == "$day" ] ; then
	# create backup directory
	mkdir /$backupdir/full/$dofbackup

	# rsync in archive mode, preserves all attrubutes, preserves hardlinks
	rsync -aAXHv --exclude={$exclusions} / $backupdir/full/$dofbackup

	# print backup to manifest file
	echo "/backup/full/$dofbackup" >> $pathtoman
	exit

elif [ "$(( $(date +"%s") - $(stat -c "%Z" /backup/full/2023-08-06-1404-fullbackup) ))" -gt "$secmax" ]; then
	
	# rsync in archive mode, preserves all attrubutes, preserves hardlinks
        rsync -aAXHv --exclude={$exclusions} / $backupdir/full/$dofbackup

        # print backup to manifest file
        echo "/backup/full/$dofbackup" >> $pathtoman
        exit
else
	rsync -aAXHv --exclude={$exclusions} --inplace --backup --backup-dir=$backupdir/$doibackup / /$backupdir/full/$dofbackup
	exit
fi










# create backup directory
#mkdir /backup/full/$dofbackup

# rsync in archive mode, preserves all attrubutes, preserves hardlinks
#rsync -aAXHv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/backup/full/*","/backup/inc/*","/usr/local/packages/*"} / /backup/full/$dofbackup

# print backup to manifest file
#echo "/backup/full/$dofbackup" >> /backup/manifest.txt

#tar and compress backup, then deletes backup
#tar -czf /backups/fullbackups/$dofbackup.tar /backups/fullbackups/$dofbackup
#echo "chill"
#sleep 5
#rm -rf /backups/fullbackups/$dofbackup

