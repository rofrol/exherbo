# http://unix.stackexchange.com/questions/38204/how-to-setup-virtual-box-guest-additions-drivers-on-systemd-system-exherbo
# http://wiki.gentoo.org/wiki/VirtualBox
# http://packages.gentoo.org/package/app-emulation/virtualbox-guest-additions
# http://packages.gentoo.org/package/x11-drivers/xf86-video-virtualbox
# http://packages.gentoo.org/package/dev-util/kbuild
# http://packages.gentoo.org/package/sys-devel/bin86

# VirtualBox
wget http://download.virtualbox.org/virtualbox/4.3.4/VirtualBox-4.3.4.tar.bz2
tar xf VirtualBox-4.3.4.tar.bz2
cd VirtualBox-4.3.4/
./src/VBox/Additions/linux/export_modules vbox-kmod.tar.gz
mkdir vbox-kmod
tar xf vbox-kmod.tar.gz -C vbox-kmod/

# Dependencies
cave resolve -1 yasm -x
cave resolve repository/SuperHeron-misc -x
cave resolve -1x iasl

# Configure
./configure --nofatal --disable-xpcom --disable-sdl-ttf --disable-pulse --disable-alsa --build-headless

# kBuild
wget http://dev.gentoo.org/~polynomial-c/kBuild-0.1.9998-pre20131130-src.tar.xz
tar xz kBuild-0.1.9998-pre20131130-src.tar.xz
cd kBuild-0.1.9998-pre20131130/
cd src/kmk/
# http://stackoverflow.com/questions/10999549/how-do-i-create-a-configure-script
autoreconf -i
cd ../sed/
sed 's@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@' -i configure.ac
autoreconf -i --force
kBuild/env.sh --full make -f bootstrap.gmk AUTORECONF=true AR="ar"
D=$PWD/out
mkdir test
kBuild/env.sh kmk NIX_INSTALL_DIR=test PATH_INS="${D}" install
export PATH=$PATH:$PWD/out/linux.amd64/release/stage/test/bin
