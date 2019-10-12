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
    INSTALL_DIR="/usr/local/GrowSense/Index"
fi

echo "  Branch: $BRANCH"
echo "  Install dir: $INSTALL_DIR"

echo "  WiFi Name: $WIFI_NAME"
echo "  WiFi Password: [hidden]"

echo "  MQTT Host: $MQTT_HOST"
echo "  MQTT Username: $MQTT_USERNAME"
echo "  MQTT Password: [hidden]"
echo "  MQTT Port: $MQTT_PORT"

echo "  SMTP server: $SMTP_SERVER"
echo "  Admin email: $ADMIN_EMAIL"

INDEX_DIR="$INSTALL_DIR"
GREENSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GREENSENSE_DIR)"

echo ""
echo "Creating ArduinoPlugAndPlay dir..."
PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"
mkdir -p $PNP_INSTALL_DIR || exit 1

cd $PNP_INSTALL_DIR

echo ""
echo "Importing GrowSense config file into ArduinoPlugAndPlay dir..."

wget -q --no-cache https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts/apps/ArduinoPlugAndPlay/ArduinoPlugAndPlay.exe.config.system -O $PNP_INSTALL_DIR/ArduinoPlugAndPlay.exe.config || exit 1

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  fi
fi

echo ""
echo "Setting up GrowSense index..."

if [ ! -d "$INDEX_DIR/.git" ]; then
  $SUDO mkdir -p $INDEX_DIR || exit 1

  if [ -d $INDEX_DIR ]; then
    echo "Moving the existing GrowSense index..."

    $SUDO mv $INDEX_DIR $INDEX_DIR.old
  fi

  echo ""
  echo "Installing git"
  sudo apt-get install -y git || exit 1

  echo ""
  echo "Cloning the GrowSense index repository..."

  $SUDO git clone --depth 1 --recursive https://github.com/GrowSense/Index.git "$INDEX_DIR" --branch $BRANCH || exit 1

  if [ -d $INDEX_DIR.old ]; then
    echo "Importing pre-existing *.txt files..."
    mv $INDEX_DIR.old/*.txt $INDEX_DIR/


    if [ -d $INDEX_DIR.old/remote ]; then
      echo "Importing pre-existing remote folder..."
      mv $INDEX_DIR.old/remote $INDEX_DIR/remote
    fi

    echo ""
    echo "Removing old index directory..."
    rm -r $INDEX_DIR.old
  fi

  echo ""
  echo "Moving into index directory..."

  cd $INDEX_DIR || exit 1

  echo ""
  echo "Preparing index..."

  $SUDO bash prepare.sh || exit 1
fi

echo ""
echo "Moving into the index directory..."

cd $INDEX_DIR || exit 1

echo ""
echo "Updating the index..."

$SUDO sh update.sh || exit 1

echo ""
echo "Initializing runtime components..."

$SUDO bash init-runtime.sh || exit 1

echo ""
echo "Installing apps (so it's ready to run offline)..."

$SUDO bash install-apps.sh || exit 1

echo ""
echo "Setting WiFi credentials..."

$SUDO bash set-wifi-credentials.sh $WIFI_NAME $WIFI_PASSWORD || exit 1

echo ""
echo "Setting MQTT credentials..."

$SUDO bash set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT || exit 1

echo ""
echo "Setting email details..."

$SUDO bash set-email-details.sh $SMTP_SERVER $ADMIN_EMAIL || exit 1

echo ""
echo "Installing plug and play..."

$SUDO wget -nv --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/install.sh | bash -s -- $BRANCH $PNP_INSTALL_DIR $SMTP_SERVER $ADMIN_EMAIL || exit 1

echo ""
echo "Creating garden..."

$SUDO bash create-garden.sh || exit 1

echo ""
echo "Creating system supervisor service..."

$SUDO bash create-supervisor-service.sh || exit 1

echo ""
echo "Publishing status to MQTT..."
# Sleep for 30 seconds to give the UI controller time to load before publishing
sh run-background.sh sleep 30 && sh mqtt-publish.sh "/garden/StatusMessage" "Installed" || echo "MQTT publish failed."

echo ""
echo "Finished installing GrowSense plug and play."
