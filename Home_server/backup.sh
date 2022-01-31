#!/bin/bash

set +x

backupdir="root@192.168.32.3:/misc/cryptbackup"
rootdir=/nas/
script=$(readlink -f $0)
TODAY=$(date +"%s")

INCLUDE=/tmp/backmeup-include.tmp
EXCLUDE=/tmp/backmeup-exclude.tmp

# Obvious truncating is obvious
> $INCLUDE
> $EXCLUDE

cd $rootdir

# %h is the containing directory of the found file.
# Quoting the items so spaces are treated correctly
echo "Finding backup folders"
find -L . -name '.BACKMEUP' -printf "%h\n" > $INCLUDE
echo "Finding excluded folders"
cat $INCLUDE | while read LINE; do
  echo "$LINE"
  find -L "$LINE" -name '.DONOTBACKMEUP' -printf "%h/*\n" | cut -c 3- >> $EXCLUDE
  find -L "$LINE" -name 'Trash'  -printf "%p/*\n" | cut -c 3- >> $EXCLUDE
done

echo "Source dir: $rootdir"

echo "Included directories"
cat $INCLUDE
echo
echo "Excluding the following items:"
cat $EXCLUDE
echo


sleep 5

rsync -arP --delete-excluded --exclude-from=$EXCLUDE --files-from=$INCLUDE $rootdir $backupdir/$rootdir

#test -d $backupdir/plex || mkdir $backupdir/plex
rsync -avP /root/plexdb/com.plexapp.plugins.library.db $backupdir/plex/
rsync -avP $script $backupdir/


echo "To delete old file from backup that are no longer in the source"
echo "Run this command:"
echo rsync -arvP --delete --delete-excluded --exclude-from=$EXCLUDE --files-from=$INCLUDE $rootdir $backupdir/$rootdir

echo "Keeping entire file list for nas"
find $rootdir | gzip -c > /tmp/filelist.txt.$TODAY.gz
rsync -avP /tmp/filelist.txt.$TODAY.gz $backupdir
rsync -avP $INCLUDE $backupdir
rsync -avP $EXCLUDE $backupdir
rm /tmp/filelist.txt.$TODAY.gz