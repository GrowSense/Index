DIR=$PWD

DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Please provide a device name as an argument."
  exit 1
fi

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

MQTT_HOST=$(cat mqtt-host.security)
MQTT_USERNAME=$(cat mqtt-username.security)
MQTT_PASSWORD=$(cat mqtt-password.security)
MQTT_PORT=$(cat mqtt-port.security)

DEVICE_PROJECT=$(cat "devices/$DEVICE_NAME/project.txt")
DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")
DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
DEVICE_PORT=$(cat "devices/$DEVICE_NAME/port.txt")

echo "  Project name: $DEVICE_PROJECT"

LATEST_BUILD_NUMBER=$(curl -sL https://raw.githubusercontent.com/GreenSense/$DEVICE_PROJECT/$BRANCH/buildnumber.txt)
LATEST_VERSION_NUMBER=$(curl -sL https://raw.githubusercontent.com/GreenSense/$DEVICE_PROJECT/$BRANCH/version.txt)

LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

VERSION=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Z" -C 1)

if [ ! "$VERSION" ]; then
  echo "  No MQTT data detected"  
else
  echo "  Device version: $VERSION"
  echo "  Latest version ($BRANCH): $LATEST_FULL_VERSION"
  
  if [ "$VERSION" = "$LATEST_FULL_VERSION" ]; then
    echo "  Already on the latest version. Skipping upload."
  else
    echo "  Needs to be updated."
    
    mkdir -p "logs/updates"
    
    cd "sketches/$DEVICE_GROUP/$DEVICE_PROJECT"
    sh clean.sh
    git pull origin $BRANCH
    cd $DIR
    
    sh systemctl.sh stop greensense-mqtt-bridge-$DEVICE_NAME.service
    
    SCRIPT_NAME="upload-$DEVICE_GROUP-$DEVICE_BOARD-sketch.sh"
    timeout 5m sh $SCRIPT_NAME $DEVICE_PORT >> logs/updates/$DEVICE_NAME.txt
    
    sh systemctl.sh start greensense-mqtt-bridge-$DEVICE_NAME.service
    
    echo "Device has been updated."    
  fi
fi

