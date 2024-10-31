#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
mode=$(cat $SCRIPT_DIR/bot.conf | grep "MODE=" | cut -d "=" -f 2)

if [ "$mode" == "4" ];then
	exit 1
fi


while ! curl ifconfig.me; do
  sleep 5
done

bash $SCRIPT_DIR/delmsg.sh

date=$(date)
rede=$(ifconfig | egrep ":\ |inet" | cut -d " " -f 1,10)

TOKEN=$(cat $SCRIPT_DIR/bot.conf | grep "TELEGRAM_TOKEN=" | cut -d "=" -f 2)
CHAT_ID=$(cat $SCRIPT_DIR/bot.conf | grep "CHAT_ID=" | cut -d "=" -f 2)

M1="<b>$date</b>"
M2="<b>$rede</b>"

mensagens=("$M1" "$M2")

echo $TOKEN
for msg in "${mensagens[@]}"
do
	message_id=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
            -d chat_id="${CHAT_ID}" \
            -d text="${msg}" \
            -d parse_mode="HTML" | jq -r .result.message_id >> $SCRIPT_DIR/.msgID)

	echo $message_id
done

if [ "$mode" == "1" ];then
	bash $SCRIPT_DIR/startReverseVPS.sh

elif [ "$mode" == "2" ];then
	bash $SCRIPT_DIR/startReverseNGROK.sh

elif [ "$mode" == "3" ];then
	bash $SCRIPT_DIR/handshake.sh &
	bash $SCRIPT_DIR/wifi.sh
else
	echo "Unknown mode $mode"
	exit 1

fi
