#!/bin/bash
declare -x SCRIPTPATH="${0}"
declare -x RUNDIRECTORY="${0%%/*}"
declare -x SCRIPTNAME="${0##*/}"
if [ "$RUNDIRECTORY" == "$SCRIPTNAME" ]; then
   RUNDIRECTORY="."
fi

. $(pwd)/conf.sh

sh mounted.sh; sh time_host.sh; sh wpa_supplicant.sh
#run 19th line: #sh install.sh 19
if [ ${1} -gt 0 ];then
 o=`eval "sed '${1}q;d' ${SCRIPTPATH}"`
 p=`echo $o | sed -e "s@\\${part}@${part}@g" -e "s@\\${distro}@${distro}@g" -e "s@\\${arch}@${arch}@g" -e "s@\\${indate}@${indate}@g" -e "s@\\${proj}@${proj}@g" -e "s@\\${backup}@${backup}@g"`
 yn "${p}"
 eval "time (${p})";
 if [ $debug -eq 1 ]; then echo -e '\a'; sleep 1; echo -e '\a'; sleep 1; echo -e '\a'; fi
fi
exit
#http://wooledge.org:8000/BashFAQ
#http://www.unixguide.net/unix/sedoneliner.shtml
#without eval redirects > won't run.
#yes no
#http://ubuntuforums.org/showpost.php?s=bea64430aa1fc9be6972519ecf2f7d21&p=7808849&postcount=9
#http://tldp.org/LDP/abs/html/exit-status.html

#bell
modprobe pcspkr

#while is for case, when you have mounted more then one time, or faster umount -l, fuser -mv /mnt/${distro}; kill -9 <pid>
#while [ `mount | grep ${distro} | wc -l` -gt 0 ] ; do umount -l /mnt/${distro}/dev; umount /mnt/${distro}/{dev,proc,sys,,mnt/usb}; done

#sleep 3 needed to detach
umount -l /mnt/${distro}/dev; sleep 3; umount /mnt/${distro}/{dev,proc,sys,var/cache/paludis/distfiles,mnt/storage,}; sh check.sh

#mkfs.btrfs -L ${distro} /dev/${part}
# -c for badblocks
mkfs.ext3 -L ${distro} /dev/${part}

[ ! -d /mnt/${distro} ] && mkdir /mnt/${distro}; [ -d /mnt/${distro} ] && mount -L ${distro} /mnt/${distro}; mount | grep ${distro}

elinks http://dev.exherbo.org/stages/
cd ${proj}/temp && wget http://dev.exherbo.org/stages/exherbo-${arch}-current.tar.xz

cd ${proj}/temp && wget http://dev.exherbo.org/stages/sha1sum
cd ${proj}/temp && LC_ALL=C sha1sum -c sha1sum 2>/dev/null | grep "exherbo-${arch}-current.tar.xz: OK"; cd -

cd /mnt/${distro} && unxz -c ${proj}/temp/exherbo-${arch}-current.tar.xz | tar xpfv -

cp ${proj}/conf/etc/fstab /mnt/${distro}/etc && cp ${proj}/conf/etc/conf.d/clock /mnt/${distro}/etc/conf.d/ && cp -L /mnt/${distro}/usr/share/zoneinfo/Europe/Warsaw /mnt/${distro}/etc/localtime && cp ${proj}/conf/etc/paludis/bashrc-${arch} /mnt/${distro}/etc/paludis/bashrc 

#if not exist create and mount, else mount
[ ! -d /mnt/${distro}/mnt/storage ] && mkdir /mnt/${distro}/mnt/storage; [ -d /mnt/${distro}/mnt/storage ] && mount -o bind /mnt/storage /mnt/${distro}/mnt/storage; mount | grep bind

mount -o bind ${proj}/temp/distfiles /mnt/${distro}/var/cache/paludis/distfiles
rsync -vaHW ${proj}/temp/distfiles/ /mnt/exherbo/var/cache/paludis/distfiles

#for rechroot
mount -o rbind /dev /mnt/${distro}/dev/ && mount -o bind /sys /mnt/${distro}/sys/ && mount -t proc none /mnt/${distro}/proc/ && cp -L /etc/resolv.conf /mnt/${distro}/etc/resolv.conf && cat /proc/mounts > /mnt/${distro}/etc/mtab; mount | grep ${distro}

chroot /mnt/${distro} /bin/bash

# chrooted #####################################################################

date
sh ${proj}/locale.sh

#glib failed to update, chrooted from sysrescuecd, use ubuntu live
unset path
passwd
eclectic env update
#source doesn't work, only for script env
#source /etc/profile
export PS1="(chroot) $PS1"
#do not sync before paludis -i paludis
paludis -i paludis
paludis -s
#unset needed for sysrescuecd, or zsh
unset path && paludis -i sydbox
paludis -i glibc
#python fails, add 
#labels have changes, or backup ndbam and replace s/build,run/build+run/
#rm -R /var/cache/paludis/metadata/* && 
#The 'everything' set is deprecated. Use either 'installed-packages' or 'installed-slots' instead
paludis -ip installed-packages --dl-reinstall if-use-changed --dl-upgrade always 2>&1 | tee ${proj}/temp/e.log
#--dl-suggested install
#add repo hardware
#options already copied
#echo "net-wireless/wpa_supplicant ssl" >> /etc/paludis/options.conf && 
paludis -i iwlwifi-3945-ucode wpa_supplicant wireless_tools
#grub-static is installed? and it won't upgrade on x86 beaces is keyworded ~amd64; at this moment grub can't be compiled on amd64
mv /etc/init.d/net.eth0 /etc/init.d/net.wlan0; cp ${proj}/conf/etc/conf.d/net.wlan0 /etc/conf.d/net; cp ${proj}/conf/etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/;

elinks http://rofrol.wordpress.com/2009/10/12/iwl3945-linux-2-6-31/
#paludis -i vanilla-sources no longer works since all sources has been removed
elinks kernel.org and download kernel and unpack it; enable kconfig
tar -vpxjf ${proj}/temp/linux*.tar.bz2 -C /usr/src
#ln -s /usr/src/linux... /usr/src/linux or use eclectic
eclectic kernel set 1
#it should work in busybox, but in bash? http://www.openchill.org/?cat=9
yes ? | make -s oldconfig
cd /usr/src/linux && make menuconfig && make && make modules_install && make install

enable ctrl+alt+del in /etc/inittab

wget http://altruistic.lbl.gov/mirrors/ubuntu/pool/universe/m/mc/mc_4.6.2-2.diff.gz
wget http://ftp.debian.org/debian/pool/main/m/mc/mc_4.7.0-pre1-3.diff.gz
#irssi config generator: make-irssi-config.sh < http://www.matthew.ath.cx/programs/irssiconfig < http://pl.wikibooks.org/wiki/Irssi
paludis -i elinks gpm htop mc irssi
echo "net-www/elinks gpm" >> /etc/paludis/options.conf
/etc/init.d/gpm start
eclectic rc add gpm default

sh ${proj}/grub.sh

elinks http://nouveau.freedesktop.org/wiki/ExherboInstall
elinks http://intellinuxgraphics.org/user.html
elinks http://intellinuxgraphics.org/install.html
elinks http://en.gentoo-wiki.com/wiki/Intel_GMA
#matrix with suported features
elinks http://www.x.org/wiki/IntelGraphicsDriver
elinks http://www.x.org/wiki/ModularDevelopersGuide
#how to enable ctrl+alt+backspace
elinks http://www.gentoo.org/proj/en/desktop/x/x11/xorg-server-1.6-upgrade-guide.xml

#what about VIDEO_DRIVERS: gallium-intel intel for x11-dri/mesa
#echo "*/* INPUT_DRIVERS: evdev -keyboard -mouse VIDEO_DRIVERS: intel" >> /etc/paludis/options.conf
echo "*/* VIDEO_DRIVERS: intel" >> /etc/paludis/options.conf
#encodings and fonts
#KSC5601.1987-0 font-daewoo-misc, JISX0208.1983-0 font-jis-misc, GB2312.1980-0 font-isas-misc, font-misc-misc for iso and jisx0201 and koi08-r
#problem: startx very slow, LC_ALL=C startx or install proper fonts?
#solution: install fonts with encodings listed in vim /usr/share/X11/locale/en_US.UTF-8/XLC_LOCALE or comments those encodings in this file
#/usr/share/X11/locale/en_US.UTF-8/
echo "fonts/font-misc-misc ENCODINGS: iso8859-13 iso8859-14 iso8859-15 iso8859-2 iso8859-3 iso8859-4 iso8859-5 iso8859-7 iso8859-9 jisx0201 koi8-r" >> /etc/paludis/options.conf
# eclectic-fontconfig is suggested
# cat font_list | grep -E "^\*[^:]+/"
paludis -i xorg-server --dl-suggested install
paludis -i xinit --dl-suggested install
#suggested pm-utils: Suspend and hibernation utilities for HAL
paludis -i hal --dl-suggested install
#hal and dbus is needed for evdev?
/etc/init.d/hald start
eclectic rc add hald default
paludis -i font-daewoo-misc font-jis-misc font-isas-misc

#http://en.wikipedia.org/wiki/Unicode_typefaces
#http://wiki.archlinux.org/index.php/Fonts
#http://wiki.archlinux.org/index.php/Xorg_Font_Configuration
#if you get warning: font for charset ISO8859-2 is lacking. (and others codings)
#and for TTF font warning
paludis -i liberation-fonts
#for Type1 warning
paludis -i font-xfree86-type1
#terminus-font ?

#after installing and uninstalling font-daewoo-misc and startx i got:
#Warning: Unable to load any usable fontset
#twm:  unable to open fontset "-adobe-helvetica-bold-r-normal--*-120-*-*-*-*-*-*"
#fc-cache -vf doesn't help, /usr/lib64/X11/fonts/misc/fonts.dir isn't updated 

#get firefox nigthly, need gtk+ and alsa-utils (libasound2 from alsa-lib)
echo "x11-libs/cairo X" >> /etc/paludis/options.conf 
echo "x11-libs/pango X" >> /etc/paludis/options.conf 
paludis -ip gtk+ alsa-utils

#for paludis -i gnome
wget --no-check-certificate https://fedorahosted.org/releases/x/m/xmlto/xmlto-0.0.22.tar.bz2
#add repos gnome.conf compnerd.conf media.conf perl.conf 
echo "media-libs/libcanberra gtk" >> /etc/paludis/options.conf 
echo "dev-libs/libxml2 python" >> /etc/paludis/options.conf 
echo "sys-fs/udev glib" >> /etc/paludis/options.conf 

#for paludis -i openoffice
#add repos office.conf scientific.conf

#lxde
echo "lxde-desktop/lxsession hal" >> /etc/paludis/options.conf 
echo "x11-apps/pcmanfm desktop -gamin hal" >> /etc/paludis/options.conf 
echo "x11-wm/openbox startup-notification"  >> /etc/paludis/options.conf 
#Error: no fam or gamin detected. x11-apps/pcmanfm-0.5.1::gauteh, install gamin
#leafpad hated docdir option, http://lists.exherbo.org/pipermail/exherbo-dev/2009-October/000570.html 
#so you have to add to exheres DEFAULT_SRC_CONFIGURE_PARAMS=( --hates=docdir )
paludis -i lxde-common lxde gamin
echo "startlxde" > ~/.xinitrc
#no icons: install gnome-icon-theme or choose tango from lxappearance
#missing icon on launchbar: it is firefox: ~/.config/lxpanel/LXDE/panels/panel
#http://wiki.archlinux.org/index.php/LXDE

#http://wiki.archlinux.org/index.php/Start_X_at_boot#Starting_X_as_preferred_user_without_logging_in

# backup #######################################################################

#tar
read -p "description: " desc && cd /mnt/${distro} && tar -vpcjf ${backup}/${distro}-${arch}-${indate}-${desc}.tar.bz2 --exclude "var/tmp/ccache/*" --exclude "var/tmp/paludis/build/*" --exclude "var/cache/paludis/distfiles/*" --exclude "usr/src/*" . 2>&1 | tee ${proj}/temp/tar.log && export name="${backup}/${distro}-${arch}-${indate}-${desc}.tar.bz2"

cd ${backup}/ && sha1sum ${name} > ${name}.sha1sum

cd /mnt/${distro} && tar -vpxjf ${name} 2>&1 | tee ${proj}/temp/untar.log

# deprecated ###################################################################

#rsync
rsync --delete -aHWv --stats --progress /mnt/${distro} ${backup}/${distro}-${arch}-bootable/
rsync --delete -aHWv --stats --progress --link-dest=${backup}/${distro}-${arch}-bootable /mnt/${distro} ${backup}/${distro}-${arch}-bootable-wifi_fight/

#verify
#extract backup to test and verify, only size and times by default
rsync -nvaHW --exclude "var/tmp/paludis/build/*" --exclude "var/tmp/ccache/*" /mnt/${distro}/ test/
find /mnt/${distro}/ -xdev -type f -print0 | xargs -0 -n 1 sha1sum > ${backup}/${distro}-${arch}-bootable/sha1sum
du -s -b /mnt/${distro}/ > ${backup}/${distro}-${arch}-bootable/bytes

# exherbo paludis doc ##########################################################

#list of installed packages by "paludis -i" /var/db/paludis/repositories/installed/world

#Kicktoo: install gentoo, funtoo, exherbo from one set of functions http://www.openchill.org/?cat=9

elinks /usr/share/doc/paludis-scm/index.html

#when i got error about paludis and labels change, i get stderr stdout stderr, instead of stderr stdout. Solution to this is paludis -i <package> 2>&1 | tee or /usr/share/paludis/hooks/demos/elog.bash
