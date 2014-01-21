#!/bin/bash
#WARNING: set correct /etc/localtime for chrooted and non-chrooted env
. $(pwd)/conf.sh
yn "set time for host"
#-L dereference
cp -L ${proj}/Warsaw /etc/localtime

#no /etc/conf.d/clock in sysresuecd 1.5.7
#sed -e 's/London/Warsaw/' /etc/conf.d/clock > t; mv t /etc/conf.d/clock
#sed -e 's/UTC/local/' /etc/conf.d/clock > t; mv t /etc/conf.d/clock
hwclock --hctosys --localtime

#/etc/init.d/clock restart
date
#local and Europe/Warsaw in /mnt/${distro}/etc/conf.d/clock
#date MMDDHHMM
#date MMDDHHMMYYYY
#set bios time the same as system time
#hwclock --systohc
#hwclock --hctosys --localtime

#== ntp
#cave resolve ntp
#systemd start ntpd
#systemd enable ntpd
#ntp wasn't syncing time and systemctl status ntpd showed
# [/usr/lib/systemd/system/ntpd.service:9] Unknown lvalue 'ControlGroup' in section 'Service'
#deleting line with ControlGroup in file /usr/lib64/systemd/system/ntpd.service helped
#https://bugs.archlinux.org/task/36339
#https://bugzilla.redhat.com/show_bug.cgi?id=1011047
