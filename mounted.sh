#!/bin/bash
. $(pwd)/conf.sh

yn "check mounts"
#don't cat /proc/mounts /etc/mtab inside chroot, because now (20091020) /proc/mounts and <chrooted>/proc/mounts aren't the same

C_NOR="\033[0m"
C_OK="\033[1;32m"
C_FAIL="\033[1;31m"

function f_check()
{
what=${1}
if [ `mount | grep "${what}" | wc -l` -eq 1 ]; then
echo -e `mount | grep "${what}" | sed -e "s/\(.*\)/\1 [ \\\\${C_OK}OK\\\\${C_NOR} ]/g"`;
else
echo -e "${what} [ ${C_FAIL}FAIL${C_NOR} ]";
fi
}

f_check "/mnt/exherbo "
f_check "/mnt/exherbo/dev "
f_check "/mnt/exherbo/dev/pts "
f_check "/mnt/exherbo/sys "
f_check "/mnt/exherbo/proc "
