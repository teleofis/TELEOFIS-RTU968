#!/bin/sh

PORTS=$(ls /dev/ttyUSB*)

FIRST=$(echo $PORTS | awk -F ' ' '{print $1}')
[ -n "$FIRST" ] && RESULT=$(comgt -d $FIRST -s findconsole.comgt)
if [ "$RESULT" == "OK" ]; then 
	echo $FIRST 
	exit 0
fi

SECOND=$(echo $PORTS | awk -F ' ' '{print $2}')
[ -n "$SECOND" ] && RESULT=$(comgt -d $SECOND -s findconsole.comgt)
if [ "$RESULT" == "OK" ]; then 
	echo $SECOND 
	exit 0
fi

THIRD=$(echo $PORTS | awk -F ' ' '{print $3}')
[ -n "$THIRD" ] && RESULT=$(comgt -d $THIRD -s findconsole.comgt)
if [ "$RESULT" == "OK" ]; then 
	echo $THIRD 
	exit 0
fi

exit 1