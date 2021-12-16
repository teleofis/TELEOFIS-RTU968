#!/bin/sh

while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./beep.sh [option]"
	  echo "Options:"
	  echo " -d - console port"
	  echo "Example: beep.sh -d /dev/ttyUSB0"
	  exit 0
	;;
	d) device=$OPTARG
	;;
	p) port=$OPTARG
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

echo "echo 65 > /sys/class/gpio/export" > $device
sleep 0.4
echo "echo high > /sys/class/gpio/gpio65/direction" > $device
sleep 0.2
echo "echo low > /sys/class/gpio/gpio65/direction" > $device
sleep 0.4
echo "echo high > /sys/class/gpio/gpio65/direction" > $device
sleep 0.2
echo "echo low > /sys/class/gpio/gpio65/direction" > $device
sleep 0.4
echo "echo high > /sys/class/gpio/gpio65/direction" > $device
sleep 0.2
echo "echo low > /sys/class/gpio/gpio65/direction" > $device
sleep 0.4
echo "echo 65 > /sys/class/gpio/unexport" > $device
echo "BEEP OK"

exit 0
