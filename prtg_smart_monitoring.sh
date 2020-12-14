#!/bin/sh

# Async IT Sàrl - Switzerland
# Jonas Sauge

# This script is a fusion and modification of different works to fit our needs:
# https://github.com/randadinata/smart-prtg-sensor-xml/blob/master/smart.sh
# https://ep.gnt.md/index.php/how-to-check-linux-hdd-s-m-a-r-t-with-prtg-sensor
# https://github.com/andygajetzki/prtg-sensors/blob/master/scriptsxml/smart.sh

# USE:
# On the server side:
#	Place oid.smart.test.ovl in PRTG installation folder in \lookups\custom
#	Reboot PRTG Core Service
# On the device side:
# 	Put script in /var/prtg/scriptsxml/ - if folder does not exist, create it
# 	Edit the script if you want to have all smart values - uncomment "ALL SMART VALUES"
# 	Add advanced ssh script sensor
# 	Name sensor and select the script - adjust Scan interval in case of need
# 	Add sensor


# Smart CTL outputs:
# https://linux.die.net/man/8/smartctl

# Version:
# Version 1.0 - Initial release
# Version 1.1 - Removed drive path from sensor nas as it's kind of usless.
# Version 2.0 - Add SMART status retreiving using exit code - set values
# Version 2.1 - Add case if there's more than 1 error
# Version 2.2 - Automatically set value lookup
# Version 2.3 - Add support when device does not have SMART support
# Version 2.4 - Add check for keyword that may indicate failures - experience showed only checkink for smart status exit code is not enough

SMARTCTL="/usr/sbin/smartctl"

echo "<prtg>"
for DEVICE in `$SMARTCTL --scan-open | grep -o "^/dev/[0-9A-Za-z]*"`; do
  echo "	<result>"
  $SMARTCTL -H $DEVICE > /dev/null
  varstatus=$?
  
  if [ "$varstatus" -eq 0 ]; then
    smart_status=$($SMARTCTL -a $DEVICE)
    if echo $smart_status | egrep -wqi 'failure' ; then
		echo "		<value>4</value>"
		else
        echo "		<value>0</value>"
    fi
  elif [ "$varstatus" -eq 255 ]; then
    echo "		<value>1</value>"
  elif [ "$varstatus" -eq 2 ]; then
    echo "		<value>2</value>"
  elif [ "$varstatus" -eq 4 ]; then
   echo "		<value>3</value>"
  elif [ "$varstatus" -eq 8 ]; then
    echo "		<value>4</value>"
  elif [ "$varstatus" -eq 16 ]; then
    echo "		<value>5</value>"
  elif [ "$varstatus" -eq 32 ]; then
    echo "		<value>6</value>"
  elif [ "$varstatus" -eq 64 ]; then
    echo "		<value>7</value>"
  elif [ "$varstatus" -eq 128 ]; then
    echo "		<value>8</value>"
  elif [ "$varstatus" -gt 1 ]; then
    echo "		<value>9</value>"
  fi;
  echo "		<channel>SMART: $DEVICE</channel>"
  echo "		<unit>Custom</unit>"
  echo "    <ValueLookup>oid.smart.test</ValueLookup>"
  echo "</result>"
  
# -------------- All SMART VALUES ---------------------
# $SMARTCTL -A $DEVICE | grep '^[ 0-9][ 0-9][0-9]' | awk '{print "<result>" "\n\t<channel>'"$DEVICE"': " $2 "</channel>\n" "\t<value>" $10 "</value>\n" "</result>"}';

done;
echo "</prtg>"
