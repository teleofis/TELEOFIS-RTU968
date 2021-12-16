#!/bin/sh

while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./checkleds.sh [option]"
	  echo "Options:"
	  echo " -d - console port"
	  echo "Example: checkleds.sh -d /dev/ttyUSB0"
	  exit 0
	;;
	d) device=$OPTARG
	;;
	p) port=$OPTARG
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

echo "echo high > /dev/pd0/direction" > $device
sleep 0.5
echo "echo low > /dev/pd0/direction" > $device
sleep 0.3
echo "echo high > /dev/pd1/direction" > $device
sleep 0.5
echo "echo low > /dev/pd1/direction" > $device
sleep 0.3
echo "echo high > /dev/pd2/direction" > $device
sleep 0.5
echo "echo low > /dev/pd2/direction" > $device
sleep 0.3
echo "echo high > /dev/pd3/direction" > $device
sleep 0.5
echo "echo low > /dev/pd3/direction" > $device
sleep 0.3
echo "LEDS OK"

exit 0
