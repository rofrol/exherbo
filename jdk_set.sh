#!/usr/bin/env bash
function log {
	[ "$LOG" == "DEBUG" ] && echo "$@"
}

dir="$1"
cd $dir/bin
for i in *; do ln -sf $PWD/$i /usr/bin/; done

cat > /etc/profile.d/java.sh <<EOF
export JAVA_HOME=$dir
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
cat <<!
Settings saved in /etc/profile.d/java.sh

To update env run:

source /etc/profile
printenv JAVA_HOME
!
