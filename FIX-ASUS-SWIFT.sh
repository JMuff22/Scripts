#!/bin/bash
xrandr --newmode "2560x1440@60" 241,500 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
xrandr --addmode DP-2 2560x1440@60
# either change mode in system pref or 
xrandr --output DP-2 --mode 2560x1440@60
# https://askubuntu.com/questions/621643/can-not-set-proper-resolution-on-this-one-monitor
