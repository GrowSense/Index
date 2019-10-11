echo "Installing GrowSense plug and play..."

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

EXAMPLE_COMMAND="Example:\n..sh master '?' [WiFiName] [WiFiPassword] [MqttHost] [MqttUsername] [MqttPassword] [MqttPort] [SmtpServer] [AdminEmail]"

if [ ! $WIFI_NAME ]; then
    echo "Specify WiFi network name as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ ! $WIFI_PASSWORD ]; then
    echo "Specify WiFi network password as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ ! $MQTT_HOST ]; then
    echo "Specify MQTT host address as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ ! $MQTT_USERNAME ]; then
    echo "Specify MQTT username as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ ! $MQTT_PASSWORD ]; then
    echo "Specify MQTT password as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ ! $MQTT_PORT ]; then
    MQTT_PORT="1883"
fi

echo "WiFi Name: $WIFI_NAME"
echo "WiFi Password: [hidden]"

echo "MQTT Host: $MQTT_HOST"
echo "MQTT Username: $MQTT_USERNAME"
echo "MQTT Password: [hidden]"
echo "MQTT Port: $MQTT_PORT"


echo "Setting up GrowSense index credentials..."


if [ ! -d "$INSTALL_DIR" ]; then
  echo "Creating the install directory..."
  mkdir -p "$INSTALL_DIR" || (echo "Failed to create install directory." && exit 1)
fi

cd $INSTALL_DIR || (echo "Failed to move into install directory." && exit 1)

echo "Downloading and running the set-wifi-credentials.sh script..."

wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/set-wifi-credentials-from-web.sh | bash -s $BRANCH "$INSTALL_DIR" $WIFI_NAME $WIFI_PASSWORD  || (echo "Failed to set WiFi credentials." && exit 1)

wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/set-mqtt-credentials-from-web.sh | bash -s $BRANCH "$INSTALL_DIR" $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT  || (echo "Failed to set MQTT credentials." && exit 1)

echo "Finished setting credentials."
