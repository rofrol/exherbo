#!/bin/bash
#WARNING: set correct /etc/localtime for chrooted and non-chrooted env
. $(pwd)/conf.sh
yn "set time for host"
cp ${proj}/temp/localtime /etc/localtime
sed -e 's/London/Warsaw/' /etc/conf.d/clock > t; mv t /etc/conf.d/clock
sed -e 's/UTC/local/' /etc/conf.d/clock > t; mv t /etc/conf.d/clock
cp -L temp/localtime /etc/
/etc/init.d/clock restart
date
#local and Europe/Warsaw in /mnt/${distro}/etc/conf.d/clock
#date MMDDHHMM
#date MMDDHHMMYYYY
#set bios time the same as system time
#hwclock --systohc
#hwclock --hctosys --localtime

