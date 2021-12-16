#!/bin/sh

VIDPID="1e0e:9001"

while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./checkusb.sh [option]"
	  echo "Options:"
	  echo " -d - console port"
	  echo "Example: checkusb.sh -d /dev/ttyUSB0"
	  exit 0
	;;
	d) device=$OPTARG
	;;
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

RESULT=$(COMMAND=$VIDPID comgt -d $device -s findusb.comgt)
if [ "$RESULT" = "OK" ]; then 
	echo "USB OK: device with VID:PID $VIDPID detected"
else
	echo "USB: device with VID:PID $VIDPID not found"
fi

exit 1
