echo "dev-lang/icedtea7 bootstrap" >> /etc/paludis/options.conf
cave resolve jdk -x
#remvoe bootstrap flag
cave resolve jdk -x

#http://lists.exherbo.org/pipermail/exherbo-dev/2012-September/001142.html

#<SardemFF7> There is no more sun jdk around.
#<SardemFF7> icedtea is the only maintained one (either upstream and in Exherbo)
#<SardemFF7> you can revive the sun-jdk-bin package from graveyard, and maintain it
#then echo "dev-lang/icedtea7" >> /etc/paludis/package_mask.conf
