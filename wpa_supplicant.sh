#!/bin/bash
. $(pwd)/conf.sh
yn "set wlan"
wpa_supplicant -d -B -iwlan0 -cwpa_supplicant.conf -Dwext
dhcpcd -d wlan0
ping -c 3 google.com
