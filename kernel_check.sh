#!/usr/bin/env bash
#https://blogs.oracle.com/fatbloke/entry/speeding_up_your_linux_guests
config="$1"
err=0

function log() {
[ "$DEBUG" == "1" ] && echo "$@"
}

function check() {
config="$1"
exp="$2"
key=${exp%%=*}
val=$(echo $exp | grep -Po '.*=\K.*')
[ "$val" == "n" ] && exp="# $key is not set"

act=$(grep "$key is not set" $config)
[ -z "$act" ] && act=$(grep "$key=" $config)

[ ! "$exp" == "$act" ] && echo "\"$exp\" != \"$act\"" && err=$[err+1]
}

#http://serverfault.com/questions/72476/clean-way-to-write-complex-multi-line-string-to-a-variable
read -d '' params <<"EOF"
# systemd https://galileo.mailstation.de/wordpress/?p=48
CONFIG_DEVTMPFS=y
CONFIG_CGROUPS=y
CONFIG_INOTIFY_USER=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EPOLL=y
CONFIG_NET=y
CONFIG_SYSFS=y
# Udev will fail to work with the legacy layout
CONFIG_SYSFS_DEPRECATED=n
# Legacy hotplug slows down the system and confuses udev
CONFIG_UEVENT_HELPER_PATH=""
# Userspace firmware loading is deprecated
CONFIG_FW_LOADER_USER_HELPER=n
# Some udev rules and virtualization detection relies on it
CONFIG_DMIID=y
# Mount and bind mount handling might require it

# Optional but strongly recommended
CONFIG_FHANDLE=y
CONFIG_IPV6=y
CONFIG_AUTOFS4_FS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_SECCOMP=y

# get config from image http://stackoverflow.com/questions/14958192/getting-config-from-linux-kernel-image
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
EOF

while read -r line; do
	if [[ $line == \#* ]] || [[ -z $line ]] ; then
		continue
	fi
	check $config $line
done <<< "$params"

[ "$err" -ne 0 ] && exit 1
exit 0
