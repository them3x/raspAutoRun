
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")


if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi


apt update
apt install iw wireless-tools ssh autossh screen wifite jq -y

echo "
[Unit]
Description=Abre tunnel reverso
[Unit]
Description=Abre tunnel reverso
After=network-online.target sshd.service
Wants=network-online.target

[Service]
Type=forking
User=root
ExecStart=$SCRIPT_DIR/start.sh

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/autorun.service


systemctl enable systemd-networkd-wait-online.service
systemctl enable autorun.service

echo "OK!"
echo "To start the script, edit the bot.conf file and restart raspbarry"
