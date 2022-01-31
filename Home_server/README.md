# Scripts for Home NAS server 

- ZFS Scrubbing
- ZFS snapshotting
- backing up
- Checking ZFS 


## To-Do

- Add BTRFS + EXT4 versions (mdadm) 
-  Description of how the home NAS works with scrubbing and backup


## `check_zfs.sh`

`etc/cron.daily/check_zfs.sh`
This is a simple script that uses zfs's built in 'zpool status -x' to send me an email and discord alert should the zfs pools be faulted

## `zpool_scrub.sh`

`/etc/cron.monthly/zpool_scrub.sh`
Super simple script that initiates a scrub on the data once a month.

## `zpool_snapshot.sh`

`/etc/cron.weekly/zpool_snapshot.sh`
This script takes a rotating weekly snapshot of any and all volumes I have defined in the pools. 'week4' is dropped, week3, 2, 1 are rotated up, and week1 is created. This gives me 1 month of "oh shit I didn't mean to do that". This is done in addition to backups.

## Backups

The script crawls the entire NAS filesystem (mounted under `/nas/`) looking for files named `.BACKMEUP` and then adds the folder containing that file to a list of folders to ultimately backup. It then makes another pass on the backedup folders list looking for `.DONOTBACKMEUP` or `Trash` and adds those to an exclusion list. This way I can do things like make /home backed up, but not my `/home/me/Downloads` folder. In addition to this, it also creates a gzipped txt file of the entire filesystem, so should I lose everything, I at least have a list of things I lost, it also grabs my Plex library database file because reasons. Backup scripts are in `/etc/cron.weekly/`, I have 1 for the local backup and 1 for the remote. The IP listed in the destination below is the Wireguard client IP of the remote Rpi. Root login is enabled, but only from this host and root passwords are disabled, keys only.


## Source

https://old.reddit.com/r/HomeServer/comments/sgsaff/in_response_to_linus_tech_tips_recent_storage/

