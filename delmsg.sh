#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

TOKEN=$(cat $SCRIPT_DIR/bot.conf | grep "TELEGRAM_TOKEN=" | cut -d "=" -f 2)
CHAT_ID=$(cat $SCRIPT_DIR/bot.conf | grep "CHAT_ID=" | cut -d "=" -f 2)

if [ -f "$SCRIPT_DIR/.msgID" ]; then
	for message_id in $(cat $SCRIPT_DIR/.msgID)
		do

			curl -o /dev/null -s -X POST "https://api.telegram.org/bot${TOKEN}/deleteMessage" \
			     -d chat_id="${CHAT_ID}" \
			     -d message_id="${message_id}"
		done

	rm $SCRIPT_DIR/.msgID
fi
