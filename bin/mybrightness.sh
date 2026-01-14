#!/bin/bash

max=$( pkexec xfpm-power-backlight-helper --get-max-brightness )
current=$( pkexec xfpm-power-backlight-helper --get-brightness )
step=$(( $max / 50 ))
min=1
percent=$(( ( $current * 100 ) / $max ))

case $1 in

# Increase
	-i)	new=$(( $current + step ))
		if [ $new -gt $max ]; then
			pkexec xfpm-power-backlight-helper --set-brightness $max
		else
			pkexec xfpm-power-backlight-helper --set-brightness $new
		fi
		exit
		;;

# Decrease
	-d)	new=$(( $current - step ))
		if [ $new -lt $min ]; then
			pkexec xfpm-power-backlight-helper --set-brightness $min
		else
			pkexec xfpm-power-backlight-helper --set-brightness $new
		fi
		exit
		;;

# Help
	-h)	echo "Usage:"
		echo "bright [-i|-d]"
		echo "bright reports the brightness level."
		echo -e "-i\t--\tIncrease brightness."
		echo -e "-d\t--\tDecrease brightness."
		echo -e "-h\t--\tHelp."
		;;

# Report
	*)	echo ""$percent"%"
		exit
		;;
esac
exit
