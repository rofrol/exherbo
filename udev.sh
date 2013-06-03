#http://serverfault.com/questions/192546/how-to-change-device-permissions-via-udev-in-rhel5
#http://serverfault.com/questions/194600/udev-how-can-i-extend-a-default-rule-to-modify-the-ownership-of-a-symlink
#https://www.virtualbox.org/ticket/5249
#mv 10-usb.rules /etc/udev/rules.d/
udevadm control --reload && udevadm trigger --verbose && ls -l /dev/bus/usb/*/*
