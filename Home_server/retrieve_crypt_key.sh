#!/bin/bash
scp pi@192.168.1.10:/home/pi/crypt.key /run/crypt.key
chown root /run/crypt.key
chmod 700 /run/crypt.key