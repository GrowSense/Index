echo "Installing GreenSense plug and play..."

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


echo "Creating ArduinoPlugAndPlay dir..."
PNP_INSTALL_DIR="/usr/local/ArduinoPlugAndPlay"
sudo mkdir -p $PNP_INSTALL_DIR || (echo "Failed to create ArduinoPlugAndPlay directory." && exit 1)

cd $PNP_INSTALL_DIR

echo "Importing GreenSense config file into ArduinoPlugAndPlay dir..."

sudo wget https://raw.githubusercontent.com/GreenSense/Index/dev/scripts/apps/ArduinoPlugAndPlay/ArduinoPlugAndPlay.exe.config.system -O ArduinoPlugAndPlay.exe.config || (echo "Failed downloading GreenSense plug and play config file." && exit 1)

echo "Setting up GreenSense index..."

INDEX_DIR="/usr/local/GreenSense/Index"

if [ ! -d "$INDEX_DIR" ]; then
  sudo git clone --recursive https://github.com/GreenSense/Index.git "$INDEX_DIR" || (echo "Failed to set up GreenSense index." && exit 1)
  
  cd $INDEX_DIR || (echo "Failed to move into GreenSense index" && exit 1)  
  
  sudo sh prepare.sh || (echo "Failed to prepare index" && exit 1)
fi

cd $INDEX_DIR || (echo "Failed to move into GreenSense index" && exit 1)

sudo sh update.sh || (echo "Failed to update GreenSense index" && exit 1)

sudo sh init-runtime.sh || (echo "Failed to initialize runtime components" && exit 1)

echo "Setting WiFi credentials..."

sudo sh set-wifi-credentials.sh $WIFI_NAME $WIFI_PASSWORD || (echo "Failed to set WiFi credentials" && exit 1)

echo "Setting MQTT credentials..."

sudo sh set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT || (echo "Failed to set MQTT credentials" && exit 1)

echo "Creating garden..."

sudo sh create-garden.sh || (echo "Failed to create garden" && exit 1)

echo "Installing plug and play..."

wget -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/dev/scripts-web/install-from-web.sh | sudo bash -s - dev  || (echo "Failed to install ArduinoPlugAndPlay." && exit 1)


echo "Finished setting up plug and play"
