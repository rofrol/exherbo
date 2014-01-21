# http://unix.stackexchange.com/questions/17859/how-can-i-simply-adjust-monitor-color-temperture-in-x
# http://www.linux-magazine.com/Online/Features/Avoiding-Eye-Strain
# https://wiki.archlinux.org/index.php/ICC_Profiles

# http://jonls.dk/redshift/
#At night the color temperature should be set to match the lamps in your room. This is typically a low temperature at around 3000K-4000K (default is 3700K). During the day, the color temperature should match the light from outside, typically around 5500K-6500K (default is 5500K). The light has a higher temperature on an overcast day.
redshift -O $1
