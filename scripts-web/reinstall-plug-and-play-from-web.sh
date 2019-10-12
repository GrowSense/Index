echo "Reinstalling GrowSense plug and play..."


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

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir] [WiFiName] [WiFiPassword] [MqttHost] [MqttUsername] [MqttPassword] [MqttPort] [SmtpServer] [AdminEmail]"

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi

if [ "$INSTALL_DIR" = "" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi


INDEX_DIR="$INSTALL_DIR"
GREENSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GREENSENSE_DIR)"

PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"

if [ ! -d "$INDEX_DIR" ]; then
  echo "Can't reinstall because GrowSense index wasn't found."
  exit 1
fi

cd $INDEX_DIR

if [ ! $WIFI_NAME ]; then
  if [ -f "wifi-name.security" ]; then
    WIFI_NAME=$(cat "wifi-name.security")
  fi
fi

if [ ! $WIFI_PASSWORD ]; then
  if [ -f "wifi-password.security" ]; then
    WIFI_PASSWORD=$(cat "wifi-password.security")
  fi
fi

if [ ! $MQTT_HOST ]; then
  if [ -f "mqtt-host.security" ]; then
    MQTT_HOST=$(cat "mqtt-host.security")
  fi
fi

if [ ! $MQTT_USERNAME ]; then
  if [ -f "mqtt-username.security" ]; then
    MQTT_USERNAME=$(cat "mqtt-username.security")
  fi
fi

if [ ! $MQTT_PASSWORD ]; then
  if [ -f "mqtt-password.security" ]; then
    MQTT_PASSWORD=$(cat "mqtt-password.security")
  fi
fi

if [ ! $MQTT_PORT ]; then
  if [ -f "mqtt-port.security" ]; then
    MQTT_PORT=$(cat "mqtt-port.security")
  fi
fi

if [ ! $SMTP_SERVER ]; then
  if [ -f "smtp-server.security" ]; then
    SMTP_SERVER=$(cat "smtp-server.security")
  fi
fi

if [ ! $ADMIN_EMAIL ]; then
  if [ -f "admin-email.security" ]; then
    ADMIN_EMAIL=$(cat "admin-email.security")
  fi
fi

echo "Branch: $BRANCH"
echo "Install dir: $INSTALL_DIR"

echo "WiFi Name: $WIFI_NAME"
echo "WiFi Password: [hidden]"

echo "MQTT Host: $MQTT_HOST"
echo "MQTT Username: $MQTT_USERNAME"
echo "MQTT Password: [hidden]"
echo "MQTT Port: $MQTT_PORT"

echo "SMTP server: $SMTP_SERVER"
echo "Admin email: $ADMIN_EMAIL"

echo "Publishing status to MQTT..."
sh mqtt-publish.sh "/garden/StatusMessage" "Reinstalling" || echo "MQTT publish failed."

# Give the MQTT status time to be displayed
sleep 5s

echo "Uninstalling GrowSense plug and play on remote computer..."

wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH_NAME/scripts-web/uninstall-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME || exit 1

echo "Installing GrowSense plug and play on remote computer..."

wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH_NAME/scripts-web/install-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME ? $WIFI_NAME $WIFI_PASSWORD $MASTER_MQTT_HOST $MASTER_MQTT_USERNAME $MASTER_MQTT_PASSWORD $MASTER_MQTT_PORT $SMTP_SERVER $ADMIN_EMAIL || exit 1


echo "Reinstalling plug and play..."

wget -q --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/reinstall.sh | bash -s -- $BRANCH $PNP_INSTALL_DIR $SMTP_SERVER $ADMIN_EMAIL || exit 1

# Give the UI controller time to start
sleep 15s

echo "Publishing status to MQTT..."
sh mqtt-publish.sh "/garden/StatusMessage" "Reinstalled" || echo "MQTT publish failed."

echo "Finished reinstalling GrowSense plug and play"
