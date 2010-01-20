#!/bin/bash
export part="sda2"
export proj="/mnt/storage/projects/exline"
export distro="exherbo"
export arch="amd64"
export backup="/mnt/storage/backup"
export indate=`date +%Y%m%d%H%M`
export debug=1
function yn()
{
	[ $debug -eq 1 ] && read -n1 -p "${1}? (y/n) " && [[ ! $REPLY = [yY] ]] && echo "" && exit
        echo ""
}
