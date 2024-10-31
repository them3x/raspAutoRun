#!/bin/bash


SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

TOKEN=$(cat $SCRIPT_DIR/bot.conf | grep "TELEGRAM_TOKEN=" | cut -d "=" -f 2)
CHAT_ID=$(cat $SCRIPT_DIR/bot.conf | grep "CHAT_ID=" | cut -d "=" -f 2)
NGROK=$(cat $SCRIPT_DIR/bot.conf | grep "NGROK=" | cut -d "=" -f 2)
NTOKEN=$(cat $SCRIPT_DIR/bot.conf | grep "NGROK_TOKEN=" | cut -d "=" -f 2)
SSHPORT=$(cat $SCRIPT_DIR/bot.conf | grep "SSHPORT=" | cut -d "=" -f 2)
USERRASP=$(cat $SCRIPT_DIR/bot.conf | grep "USER_RASP=" | cut -d "=" -f 2)


if [ -f "/tmp/.ngrokInfo" ]; then
	rm /tmp/.ngrokInfo
fi

$NGROK config add-authtoken $NTOKEN
$NGROK tcp $SSHPORT --log=stdout > /tmp/.ngrokInfo 2>&1 &

sleep 5

NGROKADDR=$(cat /tmp/.ngrokInfo | grep "url=tcp:" | cut -d "/" -f 5 | cut -d ":" -f 1)
NGROKPORT=$(cat /tmp/.ngrokInfo | grep "url=tcp:" | cut -d "/" -f 5 | cut -d ":" -f 2)


M1="<b>TUNEL NGROK</b>"
M2="<b>ssh -p $NGROKPORT $USERRASP@$NGROKADDR</b>"

mensagens=("$M1" "$M2")

for msg in "${mensagens[@]}"
do
        message_id=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
            -d chat_id="${CHAT_ID}" \
            -d text="${msg}" \
            -d parse_mode="HTML" | jq -r .result.message_id >> $SCRIPT_DIR/.msgID)

done
