#!/bin/bash
export part="sda1"
export projname="exline"
export proj="/mnt/"${projname}
export distro="exherbo"
export arch="amd64"
export backup="/mnt/storage/backup"
export indate=`date +%Y%m%d%H%M`
export beeper=0
export yesno=1

export KERNEL_VERSION="2.6.37"
function yn()
{
	[ $yesno -eq 1 ] && read -n1 -p "${1}? (y/n) " && [[ ! $REPLY = [yY] ]] && echo "" && exit
        echo ""
}
