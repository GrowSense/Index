echo "Installing GreenSense plug and play..."


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

if [ "$INSTALL_DIR" = "?" ]; then
    INSTALL_DIR="/usr/local/GreenSense/Index"
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

INDEX_DIR="$INSTALL_DIR"
GREENSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GREENSENSE_DIR)"

echo "Creating ArduinoPlugAndPlay dir..."
PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"
mkdir -p $PNP_INSTALL_DIR || (echo "Failed to create ArduinoPlugAndPlay directory." && exit 1)

cd $PNP_INSTALL_DIR

echo "Importing GreenSense config file into ArduinoPlugAndPlay dir..."

wget --no-cache https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts/apps/ArduinoPlugAndPlay/ArduinoPlugAndPlay.exe.config.system -O $PNP_INSTALL_DIR/ArduinoPlugAndPlay.exe.config || (echo "Failed downloading GreenSense plug and play config file." && exit 1)

echo "Setting up GreenSense index..."

if [ ! -d "$INDEX_DIR/.git" ]; then
  mkdir -p $INDEX_DIR || (echo "Failed to create GreenSense index directory" && exit 1)

  if [ -d $INDEX_DIR ]; then
    mv $INDEX_DIR $INDEX_DIR.old
  fi
  
  git clone --recursive https://github.com/GreenSense/Index.git "$INDEX_DIR" --branch $BRANCH || (echo "Failed to set up GreenSense index." && exit 1)
  
  if [ -d $INDEX_DIR.old ]; then
    mv $INDEX_DIR.old/*.txt $INDEX_DIR/
    
    rm -r $INDEX_DIR.old || (echo "Failed to remove old index directory" && exit 1)
  fi
  
  cd $INDEX_DIR || (echo "Failed to move into GreenSense index" && exit 1)  
  
  bash prepare.sh || (echo "Failed to prepare index" && exit 1)
fi

cd $INDEX_DIR || (echo "Failed to move into GreenSense index" && exit 1)

sh update.sh || (echo "Failed to update GreenSense index" && exit 1)

sh init-runtime.sh || (echo "Failed to initialize runtime components" && exit 1)

echo "Setting WiFi credentials..."

sh set-wifi-credentials.sh $WIFI_NAME $WIFI_PASSWORD || (echo "Failed to set WiFi credentials" && exit 1)

echo "Setting MQTT credentials..."

sh set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT || (echo "Failed to set MQTT credentials" && exit 1)

echo "Setting email detiails..."

sh set-email-details.sh $SMTP_SERVER $ADMIN_EMAIL || (echo "Failed to set email details" && exit 1)

echo "Creating garden..."

sh create-garden.sh || (echo "Failed to create garden" && exit 1)

echo "Creating system supervisor service..."

sh create-supervisor-service.sh || (echo "Failed to create supervisor service" && exit 1)

echo "Installing plug and play..."

wget --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-web/install-from-web.sh | bash -s -- $BRANCH $PNP_INSTALL_DIR $SMTP_SERVER $ADMIN_EMAIL || (echo "Failed to install ArduinoPlugAndPlay." && exit 1)


echo "Finished setting up plug and play"
