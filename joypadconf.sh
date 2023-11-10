#!/bin/bash

# https://github.com/wizlab-it/joymap
# wget https://raw.githubusercontent.com/wizlab-it/joymap/master/joymap.c
# sudo apt install libxdo-dev 
# gcc joymap.c -lxdo -o /data/joymap
# rm joypad.c
## -9 0xff0d
## -r "Up Down"
## -s "Left Right"
## smbpasswd -a itchbox
#mpg123 /home/itchbox/itchbox/avvio.mp3
#sleep 5
## enter 0xff0d
## click pointer 0xfee0
## https://www.cl.cam.ac.uk/~mgk25/ucs/keysymdef.h
nohup /home/itchbox/itchbox/joymap -9 0xff0d -u "Up Down" -t "Left Right" 2>&1
sleep 5
xdotool click 1 > /tmp/prova.log
exit 

