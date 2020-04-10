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
SMTP_USERNAME=${11}
SMTP_PASSWORD=${12}
SMTP_PORT=${13}

EXAMPLE_COMMAND="Example:\n..sh [Branch] [InstallDir] [WiFiName] [WiFiPassword] [MqttHost] [MqttUsername] [MqttPassword] [MqttPort] [SmtpServer] [AdminEmail] [SmtpUsername] [SmtpPassword] [SmtpPort]"

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
echo "  SMTP username: $SMTP_USERNAME"
echo "  SMTP password: [hidden]"
echo "  SMTP port: $SMTP_PORT"

INDEX_DIR="$INSTALL_DIR"
GREENSENSE_DIR="$(dirname $INSTALL_DIR)"
BASE_DIR="$(dirname $GREENSENSE_DIR)"

echo ""
echo "Creating ArduinoPlugAndPlay dir..."
PNP_INSTALL_DIR="$BASE_DIR/ArduinoPlugAndPlay"
mkdir -p $PNP_INSTALL_DIR || exit 1

#cd $PNP_INSTALL_DIR

echo ""
echo "Importing GrowSense config file into ArduinoPlugAndPlay dir..."

wget -q --no-cache https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts/apps/ArduinoPlugAndPlay/ArduinoPlugAndPlay.exe.config.system -O $PNP_INSTALL_DIR/ArduinoPlugAndPlay.exe.config || exit 1

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
  if [ ! -f "is-mock-sudo.txt" ]; then
    SUDO='sudo'
  else
    echo "  Is mock sudo"
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
  echo "Installing/updating git if needed"
  curl -sL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts/install/install-git.sh | bash || exit 1

  BASE_REPO_CACHE_PATH="/usr/local"

  if [ -f "is-mock-system.txt" ]; then
    BASE_REPO_CACHE_PATH=$(readlink -m "$PWD/../../../../..")
  fi

  REPO_CACHE_PATH="$BASE_REPO_CACHE_PATH/git-cache/GrowSense/Index"
  echo "  Repository cache path:"
  echo "    $REPO_CACHE_PATH"

  echo ""
  echo "Caching repository..."
  curl -sL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/cache-repository.sh | bash -s $BRANCH $REPO_CACHE_PATH

  echo ""
  echo "Cloning the GrowSense index repository..."

  #$SUDO git clone -j 10 --depth 1 --recursive https://github.com/GrowSense/Index.git "$INDEX_DIR" --branch $BRANCH --reference /usr/local/git-cache/GrowSense/Index.reference || exit 1

  $SUDO git clone -j 10 --depth 1 --recursive $REPO_CACHE_PATH "$INDEX_DIR" --branch $BRANCH || exit 1

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
  echo "  $INDEX_DIR"

  cd $INDEX_DIR || exit 1

  echo ""
  echo "Preparing index..."

  if [ ! -f "is-mock-system.txt" ]; then
    $SUDO bash prepare.sh || exit 1
  else
    echo "[mock] $SUDO bash prepare.sh"
  fi
fi

echo ""
echo "Moving into the index directory..."

cd $INDEX_DIR || exit 1

echo ""
echo "Updating the index..."

$SUDO bash update.sh || exit 1

echo ""
echo "Updating submodules..."

$SUDO bash update-submodules.sh $BRANCH || exit 1

echo ""
echo "Initializing runtime components..."

$SUDO bash init-runtime.sh || exit 1

echo ""
echo "Installing apps (so it's ready to run offline)..."

$SUDO bash install-apps.sh || exit 1

echo ""
echo "Setting WiFi credentials..."

$SUDO bash set-wifi-credentials.sh $WIFI_NAME $WIFI_PASSWORD || exit 1
$SUDO bash set-wifi-network-credentials.sh $WIFI_NAME $WIFI_PASSWORD || exit 1

echo ""
echo "Setting MQTT credentials..."

$SUDO bash set-mqtt-credentials.sh $MQTT_HOST $MQTT_USERNAME $MQTT_PASSWORD $MQTT_PORT || exit 1

echo ""
echo "Setting email details..."

$SUDO bash set-email-details.sh $SMTP_SERVER $ADMIN_EMAIL $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT || exit 1

echo ""
echo "Installing plug and play..."

$SUDO wget -nv --no-cache -O - https://raw.githubusercontent.com/CompulsiveCoder/ArduinoPlugAndPlay/$BRANCH/scripts-ols/install.sh | bash -s -- $BRANCH $PNP_INSTALL_DIR $SMTP_SERVER $ADMIN_EMAIL $SMTP_USERNAME $SMTP_PASSWORD $SMTP_PORT || exit 1

echo ""
echo "Creating garden..."

$SUDO bash create-garden.sh || exit 1

echo ""
echo "Publishing status to MQTT..."
bash mqtt-publish.sh "garden/StatusMessage" "Installed" -r

HOST=$(cat /etc/hostname)

echo ""
echo "Sending email report..."
bash send-email.sh "GrowSense software installed on $HOST" "The GrowSense software was successfully installed on $HOST."

echo ""
echo "Creating status message file..."
bash create-message-file.sh "GrowSense software installed"

echo ""
echo "Finished installing GrowSense plug and play."
