#!/bin/sh

while getopts "h?d:p:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./checkgps.sh [option]"
	  echo "Options:"
	  echo " -d - console port"
	  echo " -p - gps port"
	  echo "Example: checkgps.sh -d /dev/ttyUSB0 -p /dev/ttyUSB1"
	  exit 0
	;;
	d) device=$OPTARG
	;;
	p) port=$OPTARG
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

echo "/etc/init.d/ntpd stop" > $device
echo "/etc/init.d/gpsd stop" > $device
echo "cat /dev/gps0 > /dev/com1 &" > $device
sleep 2

RESULT=$(comgt -d $port -s gpsdata.comgt)
if [ "$RESULT" != "ERROR" ]; then 
	RESULT=$(echo $RESULT | awk -F',' '{print $4}' | head -c 2)
	echo "GPS OK: discovered $RESULT+ satellites"
else
	echo "GPS information not found"
fi

echo "kill \$(pidof cat)" > $device

exit 0
