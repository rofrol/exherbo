#!/bin/bash
#populate /boot/grub
#http://www.gnu.org/software/grub/manual/grub.html#installation
#http://www.troubleshooters.com/linux/grub/grub.htm
#first see where are stages
paludis -k grub-static
cp -aR /lib64/grub/i386-pc/ /boot/grub
cp ${proj}/conf/boot/grub/grub.conf /boot/grub/
cd /boot/grub && ln -s grub.conf menu.lst
#grub
#grub> device (hd0) /dev/sda
#grub> root (hd0,1)
#grub> setup (hd0)
#grub> quit
