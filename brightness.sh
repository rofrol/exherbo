# http://superuser.com/a/256093
# http://askubuntu.com/questions/149054/how-to-change-lcd-brightness-from-command-line-or-via-script
val="$1"
max=$(cat /sys/class/backlight/acpi_video0/max_brightness)
echo max=$max
if [ $val -gt $max ]; then
	val=$max
fi
if [ $val -lt 0 ]; then
	val=0
fi
echo -n $val > /sys/class/backlight/acpi_video0/brightness
