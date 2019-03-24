echo "Creating Plug and Play service file..."

WIFI_NAME=$1
WIFI_PASSWORD=$2

MQTT_HOST=$3
MQTT_USERNAME=$4
MQTT_PASSWORD=$5
MQTT_PORT=$6

EXAMPLE_COMMAND="Example:\n..sh [WiFiName] [WiFiPassword] [MqttHost] [MqttUsername] [MqttPassword] [MqttPort]"

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


echo "Deploying workspace..."
INSTALL_DIR="/usr/local/ArduinoPlugAndPlay"
sudo mkdir -p $INSTALL_DIR || exit 1

cd $INSTALL_DIR

echo "Importing GreenSense config file..."

sudo wget https://raw.githubusercontent.com/GreenSense/Index/dev/scripts/apps/ArduinoPlugAndPlay/ArduinoPlugAndPlay.exe.config.system -O ArduinoPlugAndPlay.exe.config || (echo "Failed downloading GreenSense plug and play config file." && exit 1)


echo "Installing plug and play..."

wget -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/dev/scripts-web/install-from-web.sh | sudo bash -s - dev  || (echo "Failed to install ArduinoPlugAndPlay." && exit 1)

echo "Creating workspace..."
WORKSPACE_DIR="$INSTALL_DIR/workspace"
sudo mkdir -p $WORKSPACE_DIR || exit 1
cd $WORKSPACE_DIR
echo "  $WORKSPACE_DIR"

INDEX_DIR="$WORKSPACE_DIR/GreenSense/Index"

echo "Setting up GreenSense index..."

if [ ! -d "$INDEX_DIR" ]; then
  sudo wget -O - https://raw.githubusercontent.com/GreenSense/Index/master/setup-from-github.sh | sudo sh
fi
cd $INDEX_DIR

sudo sh update.sh

echo "Setting WiFi credentials..."

sudo sh set-wifi-credentials.sh $WIFI_NAME $WIFI_PASSWORD

echo "Setting MQTT credentials..."

sudo sh set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT

echo "Creating garden..."

sudo sh create-garden.sh

echo "Finished setting up plug and play"
