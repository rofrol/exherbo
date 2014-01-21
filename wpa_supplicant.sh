#!/bin/bash
. $(pwd)/conf.sh
yn "set wlan"
#wpa_supplicant -d -B -iwlp4s0 -cwpa_supplicant.conf -Dath9k
wpa_supplicant -d -B -iwlp4s0 -cwpa_supplicant.conf -Dnl80211
dhcpcd -d wlp4s0
ping -c 3 google.com
