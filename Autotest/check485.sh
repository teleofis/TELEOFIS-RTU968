#!/bin/sh
RESULT="ERROR"


while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./check485.sh [option]"
	  echo "Options:"
	  echo " -d - console port"
	  echo "Example: check485.sh -d /dev/ttyUSB0"
	  exit 0
	;;
	d) device=$OPTARG
	;;
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

echo "/etc/init.d/ntpd stop" > $device
echo "/etc/init.d/gpsd stop" > $device
echo "cat /dev/gps0 > /dev/com1 &" > $device
sleep 3

PORTS=$(ls /dev/ttyUSB*)

FIRST=$(echo $PORTS | awk -F ' ' '{print $1}')
[ -n "$FIRST" ] && [ "$FIRST" != "$device" ] && RESULT=$(comgt -d $FIRST -s gpsdata.comgt)
if [ "$RESULT" != "ERROR" ]; then 
	echo $FIRST 
	echo "kill \$(pidof cat)" > $device
	exit 0
fi

SECOND=$(echo $PORTS | awk -F ' ' '{print $2}')
[ -n "$SECOND" ] && [ "$SECOND" != "$device" ] && RESULT=$(comgt -d $SECOND -s gpsdata.comgt)
if [ "$RESULT" != "ERROR" ]; then 
	echo $SECOND 
	echo "kill \$(pidof cat)" > $device
	exit 0
fi

THIRD=$(echo $PORTS | awk -F ' ' '{print $3}')
[ -n "$THIRD" ] && [ "$THIRD" != "$device" ] && RESULT=$(comgt -d $THIRD -s gpsdata.comgt)
if [ "$RESULT" != "ERROR" ]; then 
	echo $THIRD 
	echo "kill \$(pidof cat)" > $device
	exit 0
fi

echo "kill \$(pidof cat)" > $device

exit 1
