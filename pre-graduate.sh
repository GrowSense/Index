TARGET_BRANCH=$1

echo "Checking code is ready to graduate..."

if [ ! $TARGET_BRANCH ]; then
  echo "  Please specify branch as argument."
  exit 1
fi

CURRENT_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "  Current branch: $CURRENT_BRANCH"
echo "  Target branch: $TARGET_BRANCH"

echo ""

# Serial UI controller

echo "  Checking serial 1602 shield system UI controller release exists..."
SERIAL_SYSTEM_UI_CONTROLLER_VERSION="$(cat scripts/apps/Serial1602ShieldSystemUIController/version.txt)"
SERIAL_SYSTEM_UI_CONTROLLER_RELEASE_URL="https://github.com/GrowSense/Serial1602ShieldSystemUIController/releases/download/v$SERIAL_SYSTEM_UI_CONTROLLER_VERSION-$TARGET_BRANCH/Serial1602ShieldSystemUIController.$SERIAL_SYSTEM_UI_CONTROLLER_VERSION-$TARGET_BRANCH.zip"

echo "    Version: $SERIAL_SYSTEM_UI_CONTROLLER_VERSION"
echo "    Branch: $TARGET_BRANCH"
echo "    URL: $SERIAL_SYSTEM_UI_CONTROLLER_RELEASE_URL"
echo ""

SERIAL_SYSTEM_UI_CONTROLLER_RELEASE_STATUS=$(curl --head --silent $SERIAL_SYSTEM_UI_CONTROLLER_RELEASE_URL | head -n 1)

if echo "$SERIAL_SYSTEM_UI_CONTROLLER_RELEASE_STATUS" | grep -q 404; then
  echo "  Error: Serial 1602 shield system UI controller release not found."
  exit 1
else
  echo "  Serial 1602 shield system UI controller release found."
fi

# MQTT Bridge

echo "  Checking MQTT bridge release exists..."
MQTT_BRIDGE_VERSION="$(cat scripts/apps/BridgeArduinoSerialToMqttSplitCsv/version.txt)"
MQTT_BRIDGE_RELEASE_URL="https://github.com/CompulsiveCoder/BridgeArduinoSerialToMqttSplitCsv/releases/download/v$MQTT_BRIDGE_VERSION-$TARGET_BRANCH/BridgeArduinoSerialToMqttSplitCsv.$MQTT_BRIDGE_VERSION-$TARGET_BRANCH.zip"

echo "    Version: $MQTT_BRIDGE_VERSION"
echo "    Branch: $TARGET_BRANCH"
echo "    URL: $MQTT_BRIDGE_RELEASE_URL"
echo ""

MQTT_BRIDGE_RELEASE_STATUS=$(curl --head --silent $MQTT_BRIDGE_RELEASE_URL | head -n 1)

if echo "$MQTT_BRIDGE_RELEASE_STATUS" | grep -q 404; then
  echo "  Error: MQTT bridge release not found."
  exit 1
else
  echo "  MQTT bridge release found."
fi

echo "Finished checking code is ready to graduate to master branch"
