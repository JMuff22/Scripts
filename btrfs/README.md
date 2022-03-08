Couple of scripts for btrfs 

Found these via https://github.com/linuxdabbler

Added these to my cron jobs via

`sudo crontab -e`

``
0 12 * * * bash $HOME/scripts/snaphome
0 12 * * * bash $HOME/scripts/snaproot
``