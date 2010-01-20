#!/bin/bash
#for UTF-8
#coun="en_US"; enc="UTF-8"; enc2="utf8"; ling="en"; kbd="us"; cons="ter-v32b"; dump=""
coun="pl_PL"; enc="UTF-8"; enc2="utf8"; ling="pl"; kbd="pl2"; cons="ter-v32b"; dump="ISO-8859-2"
localedef -i ${coun} -f ${enc} "${coun}.${enc}"
sed -e "s@LANG='.*'@LANG='${coun}.${enc2}'@g" /etc/profile.env > t && mv t /etc/profile.env
sed -e "s@LANG '.*'@LANG '${coun}.${enc2}'@g" /etc/profile.csh > t && mv t /etc/profile.csh
sed -e "s@LANG=.*@LANG=${coun}.${enc2}@g" /etc/env.d/02locale > t && mv t /etc/env.d/02locale
echo "*/* LINGUAS: ${ling}" >> /etc/paludis/options.conf
sed -e "s@KEYMAP=\".*\"@KEYMAP=\"${kbd}\"@g" -e "s@DUMPKEYS_CHARSET=\".*\"@DUMPKEYS_CHARSET=\"${dump}\"@g" /etc/conf.d/keymaps > t && mv t /etc/conf.d/keymaps && /etc/init.d/keymaps restart
sed -e "s@CONSOLEFONT=\".*\"@CONSOLEFONT=\"${cons}\"@g" /etc/conf.d/consolefont > t && mv t /etc/conf.d/consolefont && /etc/init.d/consolefont restart
sed -e "s@UNICODE=\".*\"@UNICODE=\"yes\"@g" /etc/rc.conf > t && mv t /etc/rc.conf
eclectic env update

echo "run manually in every console: source /etc/profile"

#http://rofrol.wordpress.com/2008/02/25/lokalizacja-gentoo-i-utf-8/
#http://www.gentoo.org/doc/pl/guide-localization.xml
#http://www.gentoo.org/doc/pl/utf-8.xml

#grep -ir en_US /etc/
#/usr/share/consolefonts/
#enc2="$(echo ${enc} | sed -e 's/-//g' | tr [:upper:] [:lower:])"
