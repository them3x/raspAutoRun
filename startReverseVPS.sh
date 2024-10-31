#!/bin/bash

#### RASP TUTORIAL
# INSTALL AUTOSSH
# apt install autossh
# ssh-key-gen
# ssh-copy-id VPSUSER@IPVPS

#### VPS TUTORIAL
# nano /etc/ssh/sshd_config (add GatewayPorts yes)

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

TOKEN=$(cat $SCRIPT_DIR/bot.conf | grep "TELEGRAM_TOKEN=" | cut -d "=" -f 2)
CHAT_ID=$(cat $SCRIPT_DIR/bot.conf | grep "CHAT_ID=" | cut -d "=" -f 2)
USER=$(cat $SCRIPT_DIR/bot.conf | grep "VPS_USER=" | cut -d "=" -f 2)
IPVPS=$(cat $SCRIPT_DIR/bot.conf | grep "VPS_IP=" | cut -d "=" -f 2)
PORTVPS=$(cat $SCRIPT_DIR/bot.conf | grep "VPS_PORT=" | cut -d "=" -f 2)
TUNNELPORT=$(cat $SCRIPT_DIR/bot.conf | grep "VPSPort_TUNNEL=" | cut -d "=" -f 2)
USERRASP=$(cat $SCRIPT_DIR/bot.conf | grep "USER_RASP=" | cut -d "=" -f 2)


if ! pgrep autossh > /dev/null; then
	autossh -M 0 -N -R $TUNNELPORT:localhost:$PORTVPS $USER@$IPVPS &
fi


M1="<b>TUNEL VPS</b>"
M2="<b>ssh -p $TUNNELPORT $USERRASP@$IPVPS</b>"

mensagens=("$M1" "$M2")

for msg in "${mensagens[@]}"
do
        message_id=$(curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
            -d chat_id="${CHAT_ID}" \
            -d text="${msg}" \
            -d parse_mode="HTML" | jq -r .result.message_id >> $SCRIPT_DIR/.msgID)

done
