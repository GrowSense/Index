echo ""
echo "Removing garden device services..."
echo ""

DEVICE_NAME=$1

echo "  Device name: $DEVICE_NAME"

SYSTEMCTL_SCRIPT="systemctl.sh"

DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")
DEVICE_BOARD=$(cat "devices/$DEVICE_NAME/board.txt")

if [ -f "is-mock-systemctl.txt" ]; then
  echo "Is mock systemctl. Using mock services directory."
  SERVICES_DIR="mock/services"
else
  SERVICES_DIR="/lib/systemd/system"
fi

echo "  Services directory: $SERVICES_DIR"

if [ "$DEVICE_BOARD" = "esp" ]; then
  echo "  ESP/WiFi device. No services need to be removed."
elif [ "$DEVICE_GROUP" = "ui" ]; then
  echo "  Stopping/disabling UI controller service.."
  sh $SYSTEMCTL_SCRIPT stop growsense-ui-1602-$DEVICE_NAME.service || echo "Failed to stop service. It may not exist."
  sh $SYSTEMCTL_SCRIPT disable growsense-ui-1602-$DEVICE_NAME.service || echo "Failed to disable service. It may not exist."

  echo "  Removing UI controller service..."
  SERVICE_FILE_NAME="growsense-ui-1602-$DEVICE_NAME.service"
  rm -f "scripts/apps/Serial1602ShieldSystemUIController/svc/$SERVICE_FILE_NAME" || echo "Failed to remove internal service file. It may not exist."
  rm -f "$SERVICES_DIR/$SERVICE_FILE_NAME" || echo "Failed to remove system level service file. It may not exist."
else
  echo "  Stopping/disabling MQTT bridge service..."
  sh $SYSTEMCTL_SCRIPT stop growsense-mqtt-bridge-$DEVICE_NAME.service || echo "Failed to stop service. It may not exist."
  sh $SYSTEMCTL_SCRIPT disable growsense-mqtt-bridge-$DEVICE_NAME.service || echo "Failed to disable service. It may not exist."

  echo "  Removing MQTT bridge service file..."
  SERVICE_FILE_NAME="growsense-mqtt-bridge-$DEVICE_NAME.service"
  rm -f scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/$SERVICE_FILE_NAME || echo "Failed to remove internal service file. It may not exist."
  rm -f "$SERVICES_DIR/$SERVICE_FILE_NAME" || echo "Failed to remove system level service file. It may not exist."
fi

echo "Finished removing garden device services."
