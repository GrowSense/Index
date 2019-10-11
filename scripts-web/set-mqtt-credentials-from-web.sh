echo "Setting MQTT credentials..."

BRANCH=$1
INSTALL_DIR=$2

MQTT_HOST=$3
MQTT_USERNAME=$4
MQTT_PASSWORD=$5
MQTT_PORT=$6

EXAMPLE_COMMAND="Example:\n..sh master '?' [WiFiName] [WiFiPassword]"

if [ ! $BRANCH ]; then
    echo "Specify branch as an argument."
    echo "$EXAMPLE_COMMAND"
    exit 1
fi

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GrowSense/Index"
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

echo "Branch: $BRANCH"
echo "Install dir: $INSTALL_DIR"

echo "MQTT Host: $MQTT_HOST"
echo "MQTT Username: $MQTT_USERNAME"
echo "MQTT Password: [hidden]"
echo "MQTT Port: $MQTT_PORT"


if [ ! -d "$INSTALL_DIR" ]; then
  echo "Creating the install directory..."
  mkdir -p "$INSTALL_DIR" || (echo "Failed to create install directory." && exit 1)
fi

cd $INSTALL_DIR || (echo "Failed to move into install directory." && exit 1)

echo "Downloading and running the set-mqtt-credentials.sh script..."

wget --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/set-mqtt-credentials.sh | bash -s $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT  || (echo "Failed to set MQTT credentials." && exit 1)

echo "Finished setting WiFi credentials."
