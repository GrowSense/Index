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

echo "  Project name: $DEVICE_PROJECT"

#LATEST_BUILD_NUMBER=$(curl -sL https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/buildnumber.txt)
#LATEST_VERSION_NUMBER=$(curl -sL https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/version.txt)
LATEST_BUILD_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/buildnumber.txt" -q -O -)
LATEST_VERSION_NUMBER=$(wget --no-cache "https://raw.githubusercontent.com/GrowSense/$DEVICE_PROJECT/$BRANCH/version.txt" -q -O -)

LATEST_FULL_VERSION="$LATEST_VERSION_NUMBER-$LATEST_BUILD_NUMBER"

# Query the device to force it to output a line of data
mosquitto_pub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/Q/in" -m "1"

# Give the device time to receive the message
sleep 2

VERSION=$(timeout 10 mosquitto_sub -h $MQTT_HOST -u $MQTT_USERNAME -P $MQTT_PASSWORD -p $MQTT_PORT -t "/$DEVICE_NAME/V" -C 1)

if [ ! "$VERSION" ]; then
  echo "  Device version: No MQTT data detected"
  echo "  Latest version ($BRANCH): $LATEST_FULL_VERSION"
else
  echo "  Device version: $VERSION"
  echo "  Latest version ($BRANCH): $LATEST_FULL_VERSION"
fi
