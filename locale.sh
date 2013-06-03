#!/bin/bash
#for UTF-8
#coun="en_US"; enc="UTF-8"; enc2="utf8"; ling="en"; kbd="us"; cons="ter-v32b"; dump=""
coun="pl_PL"; enc="UTF-8"; enc2="utf8"; ling="pl"; kbd="pl2"; cons="ter-v32b"; dump="ISO-8859-2"
#more fonts
#http://www.unifont.org/fontguide/
#http://www.gentoo.org/doc/pl/utf-8.xml
#http://git.exherbo.org/summer/packages/fonts/
localedef -i ${coun} -f ${enc} "${coun}.${enc}"
sed -i -e "s@LANG='.*'@LANG='${coun}.${enc2}'@g" /etc/profile.env
sed -i -e "s@LANG '.*'@LANG '${coun}.${enc2}'@g" /etc/profile.csh
sed -i -e "s@LANG=.*@LANG=${coun}.${enc2}@g" /etc/env.d/02locale
echo "*/* LINGUAS: ${ling}" >> /etc/paludis/options.conf
sed -i -e "s@KEYMAP=\".*\"@KEYMAP=\"${kbd}\"@g" -e "s@DUMPKEYS_CHARSET=\".*\"@DUMPKEYS_CHARSET=\"${dump}\"@g" /etc/conf.d/keymaps
#something umounts, maybe this
#/etc/init.d/keymaps restart
#more in /usr/share/consolefonts, cave resolve terminus-font
sed -i -e "s@CONSOLEFONT=\".*\"@CONSOLEFONT=\"${cons}\"@g" /etc/conf.d/consolefont
#something umounts, maybe this
#/etc/init.d/consolefont restart
sed -i -e "s@UNICODE=\".*\"@UNICODE=\"yes\"@g" /etc/rc.conf

echo "run manually in every console: . /etc/profile"

#http://rofrol.wordpress.com/2008/02/25/lokalizacja-gentoo-i-utf-8/
#http://www.gentoo.org/doc/pl/guide-localization.xml
#http://www.gentoo.org/doc/pl/utf-8.xml

#grep -ir en_US /etc/
#/usr/share/consolefonts/
#enc2="$(echo ${enc} | sed -e 's/-//g' | tr [:upper:] [:lower:])"


#the keyboard layout is set to US in vconsole.conf
# https://galileo.mailstation.de/wordpress/?p=48
# http://www.linuxfromscratch.org/lfs/view/systemd/
# http://blog.fraggod.net/2010/11/05/from-baselayout-to-systemd-setup-on-exherbo.html

# man vconsole.conf
# man 8 setfont

#some console fonts don't have a Unicode map, so they're essentially an
# index -> glyph file where index is from 0-255. A unicode map adds a
# "Unicode Code Point -> index" mapping.
#
# Most fonts in /usr/share/kbd/consolefonts should have bult-in maps
# (haven't checked though). For those that don't have it, there's the -m
# option in setfont or FONT_MAP.
#
# Without an unicode map, you must make sure the loaded font has the same
# layout as the charset you're using. Without the unicode map you can't
# use utf8
# http://archlinux.2023198.n4.nabble.com/What-is-FONT-MAP-for-td4662578.html

#https://wiki.archlinux.org/index.php/Fonts
#https://bbs.archlinux.org/viewtopic.php?id=146743

#cave resolve terminus-font

#/etc/vconsole.conf
#FONT="ter-v32b"
#FONT_MAP=8859-2_to_uni
#KEYMAP="pl2"
#
#systemctl restart systemd-vconsole-setup.service

# https://wiki.archlinux.org/index.php/Xorg#Keyboard_settings

#https://wiki.archlinux.org/index.php/Beginners%27_Guide_%28Polski%29
#http://blog.fraggod.net/2010/11/05/from-baselayout-to-systemd-setup-on-exherbo.html
