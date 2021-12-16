#!/bin/sh

RS232=""
RS485=""

WHEREIS232="./whereis232.sh"
CHECK485="./check485.sh"
CHECKGPS="./checkgps.sh"
CHECKETH1="./checketh1.sh"
CHECKETH2="./checketh2.sh"
CHECKUSB="./checkusb.sh"
CHECKLEDS="./checkleds.sh"
BEEP="./beep.sh"

while [ 1 ]; do
	echo ".....  test  started  ....."
	echo "..........................."
	RS232=$($WHEREIS232)
	if [ -z "$RS232" ]; then
		echo "RS-232 port not found"
		echo "..........................."
	else 
		echo "RS-232 port is $RS232"
		echo "..........................."
		sleep 1
		RS485=$($CHECK485 -d $RS232)
		if [ -z "$RS485" ]; then
			echo "RS-485 port not found"
			echo "..........................."
		else
			echo "RS-485 port is $RS485"
			echo "..........................."
			sleep 1
			$CHECKGPS -d $RS232 -p $RS485
			echo "..........................."
			sleep 1
		fi
		$CHECKUSB -d $RS232
		echo "..........................."
		sleep 1
		$CHECKETH1 -d $RS232
		echo "..........................."
		sleep 3 
		$CHECKETH2 -d $RS232
		echo "..........................."
		sleep 3
		$CHECKLEDS -d $RS232
		echo "..........................."
		sleep 1
		$BEEP -d $RS232
		echo "..........................."
	fi
done
