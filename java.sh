#!/usr/bin/env bash
function log {
	[ "$LOG" == "DEBUG" ] && echo "$@"
}
#echo "dev-lang/icedtea7 bootstrap" >> /etc/paludis/options.conf
#cave resolve jdk -x
#remvoe bootstrap flag
#cave resolve jdk -x

#http://lists.exherbo.org/pipermail/exherbo-dev/2012-September/001142.html

#<SardemFF7> There is no more sun jdk around.
#<SardemFF7> icedtea is the only maintained one (either upstream and in Exherbo)
#<SardemFF7> you can revive the sun-jdk-bin package from graveyard, and maintain it
#then echo "dev-lang/icedtea7" >> /etc/paludis/package_mask.conf

#sun
# http://askubuntu.com/questions/56104/how-can-i-install-sun-oracles-proprietary-java-6-7-jre-or-jdk
# http://serverfault.com/questions/50883/what-is-the-value-of-java-home-for-centos
# http://askubuntu.com/questions/175514/how-to-set-java-home-for-openjdk

#download jdk
#If it's bin, just run it and the directory will appear.

fullfile="$1"
#tar xf "$fullfile" -C /usr/lib64
#cd /usr/lib64/jdk*/bin
#for i in *; do ln -sf $PWD/$i /usr/bin/; done

# read env.adoc about env variables
filename=$(basename "$fullfile")
log "filename=$filename"
#http://stackoverflow.com/questions/218156/bash-regex-with-quotes
re="^(.*)\.tar\.[^.]+$"
log "re=$re"
if [[ "$filename" =~ $re ]]; then
	dir="${BASH_REMATCH[1]}"
else
	echo "file should be of pattern <file.tar.[a-zA-Z]+>"
	exit 1
fi
log "dir=$dir"
cat > /etc/profile.d/java.sh <<EOF
export JAVA_HOME=/usr/lib64/$dir
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
cat <<!
Settings saved in /etc/profile.d/java.sh

To update env run:

source /etc/profile
printenv JAVA_HOME
!
