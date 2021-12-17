echo "Installing GrowSense from zip file..."

BRANCH=$1
INSTALL_DIR=$2

WIFI_NAME=$3
WIFI_PASSWORD=$4

MQTT_HOST=$5
MQTT_USERNAME=$6
MQTT_PASSWORD=$7
MQTT_PORT=$8

SMTP_SERVER=$9
ADMIN_EMAIL=${10}
SMTP_USERNAME=${11}
SMTP_PASSWORD=${12}
SMTP_PORT=${13}

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir] [WiFiName] [WiFiPassword] [MqttHost] [MqttUsername] [MqttPassword] [MqttPort] [SmtpServer] [AdminEmail] [SmtpUsername] [SmtpPassword] [SmtpPort]"

#if [ ! $WIFI_NAME ]; then
#    echo "Specify WiFi network name as an argument."
#    echo "$EXAMPLE_COMMAND"
#    exit 1
#fi

#if [ ! $WIFI_PASSWORD ]; then
#    echo "Specify WiFi network password as an argument."
#    echo "$EXAMPLE_COMMAND"
#    exit 1
#fi

#if [ ! $MQTT_HOST ]; then
#    echo "Specify MQTT host address as an argument."
#    echo "$EXAMPLE_COMMAND"
#    exit 1
#fi

#if [ ! $MQTT_USERNAME ]; then
#    echo "Specify MQTT username as an argument."
#    echo "$EXAMPLE_COMMAND"
#    exit 1
#fi

#if [ ! $MQTT_PASSWORD ]; then
#    echo "Specify MQTT password as an argument."
#    echo "$EXAMPLE_COMMAND"
#    exit 1
#fi

#if [ ! $MQTT_PORT ]; then
#    MQTT_PORT="1883"
#fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi

echo "  Branch: $BRANCH"
echo "  Install dir: $INSTALL_DIR"

INDEX_DIR="$INSTALL_DIR"
GROWSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GROWSENSE_DIR)"

#SUDO=""
#if [ ! "$(id -u)" -eq 0 ]; then
#  if [ ! -f "is-mock-sudo.txt" ]; then
#    SUDO='sudo'
#  else
#    echo "  Is mock sudo"
#  fi
#fi

  echo ""
  echo "Downloading and installing GrowSense..."

  curl -sL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/GrowSense/Installer/$BRANCH/scripts-download/download-installer.sh | bash -s "$BRANCH" "$INSTALL_DIR"

#$SUDO bash set-wifi-credentials.sh $WIFI_NAME $WIFI_PASSWORD || exit 1
#$SUDO bash set-wifi-network-credentials.sh $WIFI_NAME $WIFI_PASSWORD || exit 1

#echo ""
#echo "[download-and-install.sh] Setting MQTT credentials..."

#$SUDO bash set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT || exit 1

#echo ""
#echo "[download-and-install.sh] Setting email details..."

#$SUDO bash set-email-details.sh $SMTP_SERVER $ADMIN_EMAIL $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT || exit 1

#echo ""
#echo "[download-and-install.sh] Installing plug and play..."

#$SUDO wget -nv --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/install.sh | bash -s -- $BRANCH $PNP_INSTALL_DIR $SMTP_SERVER $ADMIN_EMAIL $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT || exit 1

#echo ""
#echo "[download-and-install.sh] Creating garden..."

#$SUDO bash create-garden.sh || exit 1

#echo ""
#echo "[download-and-install.sh] Publishing status to MQTT..."
#bash mqtt-publish.sh "garden/StatusMessage" "Installed" -r

#HOST=$(cat /etc/hostname)

#echo ""
#echo "[download-and-install.sh] Sending email report..."
#bash send-email.sh "GrowSense software installed on $HOST" "The GrowSense software was successfully installed on $HOST."

#echo ""
#echo "[download-and-install.sh] Creating status message file..."
#bash create-message-file.sh "GrowSense software installed"

echo ""
echo "[download-and-install.sh] Finished installing GrowSense."
