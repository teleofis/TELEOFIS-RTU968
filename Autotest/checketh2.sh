#!/bin/sh
COUNT="0"
BCAST="192.168.99.255"
IF=""
NEEDED_IF=""

while getopts "h?d:" opt; do
	case "$opt" in
	h|\?)
	  echo "Usage: ./checketh2.sh [option]"
	  echo "Options:"
	  echo " -d - console port"
	  echo "Example: checketh2.sh -d /dev/ttyUSB0"
	  exit 0
	;;
	d) device=$OPTARG
	;;
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

IFCONF=$(ifconfig | grep HWaddr)
IF_COUNT=$(ifconfig | grep HWaddr | wc -l)

while [ "$COUNT" -ne "$IF_COUNT" ]; do
	COUNT=$(($COUNT + 1))
	PART=$(($COUNT * 5 - 4))
	IF=$(echo $IFCONF | awk -v var=$PART -F ' ' '{print $var}')
	ETH=$(ifconfig $IF | grep $BCAST)
	if [ -n "$ETH" ]; then
		NEEDED_IF="$IF"
		echo "ETH2 connected to $IF interface"
	else
		ifconfig $IF down
	fi
	sleep 2
done

sleep 3

if [ -n "$NEEDED_IF" ]; then
	echo "ETH2: trying to ping 8.8.8.8"
	RESULT=""
	RESULT=$(/bin/ping -w10 -c3 -s 8 8.8.8.8  2>/dev/null | grep rec  | awk -F'[ ]' '{print $4}')
	if [ "$RESULT" = "0" -o  "$RESULT" = "" ]; then
		echo "ETH2: failed"
	else
		echo "ETH2: success"
	fi

	sleep 1

	echo "ETH2: trying to ping 8.8.4.4"
	RESULT=""
	RESULT=$(/bin/ping -w10 -c3 -s 8 8.8.4.4  2>/dev/null | grep rec  | awk -F'[ ]' '{print $4}')
	if [ "$RESULT" = "0" -o  "$RESULT" = "" ]; then
		echo "ETH2: failed"
	else
		echo "ETH2: success"
	fi
else
	echo "ETH2 not connected"
fi

COUNT="0"
while [ "$COUNT" -ne "$IF_COUNT" ]; do
	COUNT=$(($COUNT + 1))
	PART=$(($COUNT * 5 - 4))
	IF=$(echo $IFCONF | awk -v var=$PART -F ' ' '{print $var}')
	if [ "$IF" != "$NEEDED_IF" ]; then
		ifconfig $IF up
	fi
	sleep 2
done

exit 0