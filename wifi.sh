#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
iface=$(cat $SCRIPT_DIR/bot.conf | grep "interface=" | cut -d "=" -f 2)

if [ "$iface" == "auto" ];then
	iface=$(iwconfig 2> /dev/null | grep "IEEE" | grep -v "wlan0" | awk '{print $1}')

	if [ -z "$iface" ];then
		iface=$(iwconfig 2> /dev/null | grep "IEEE" | awk '{print $1}' | head -n 1)
		if [ -z "$iface" ];then
			echo "unidentified interface"
			exit 1
		fi

	fi

else
	if [ -z $(iwconfig 2> /dev/null | grep "IEEE" | grep  "$iface" | awk '{print $1}') ]; then
		echo "Interface $iface don't found"
		exit 1
	fi
fi


iface=$(airmon-ng start $iface | grep "monitor mode vif enabled on" | cut -d "]" -f2| cut -d ")" -f1)

cd $SCRIPT_DIR
screen -dmS wifite bash -c "wifite --infinite --no-wps --wpa --clients-only -p 20 --pmkid-timeout 20 --skip-crack -i $iface"

