echo ""
echo "Removing garden device services..."
echo ""

DEVICE_NAME=$1

SYSTEMCTL_SCRIPT="systemctl.sh"

DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")


if [ -f "is-mock-systemctl.txt" ]; then
  echo "Is mock systemctl. Using mock services directory."
  SERVICES_DIR="mock/services"
else
  SERVICES_DIR="/lib/systemd/system"
fi

echo "  Services directory: $SERVICES_DIR"

if [ "$DEVICE_GROUP" = "ui" ]; then
  echo "  Stopping/disabling UI controller service.." && \
  sh $SYSTEMCTL_SCRIPT stop greensense-ui-1602-$DEVICE_NAME.service || echo "Failed to stop service. It may not exist."
  sh $SYSTEMCTL_SCRIPT disable greensense-ui-1602-$DEVICE_NAME.service || echo "Failed to disable service. It may not exist."
  
  echo "  Removing UI controller service..." && \
  SERVICE_FILE_NAME="greensense-ui-1602-$DEVICE_NAME.service"
  rm -f "scripts/apps/Serial1602ShieldSystemUIController/svc/$SERVICE_FILE_NAME" || echo "Failed to remove internal service file. It may not exist."
  rm -f "$SERVICES_DIR/$SERVICE_FILE_NAME" || echo "Failed to remove system level service file. It may not exist."
else
  echo "  Stopping/disabling MQTT bridge service..." && \
  sh $SYSTEMCTL_SCRIPT stop greensense-mqtt-bridge-$DEVICE_NAME.service || echo "Failed to stop service. It may not exist."
  sh $SYSTEMCTL_SCRIPT disable greensense-mqtt-bridge-$DEVICE_NAME.service || echo "Failed to disable service. It may not exist."

  echo "  Removing MQTT bridge service file..." && \
  rm -f scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/greensense-mqtt-bridge-$DEVICE_NAME.service || echo "Failed to remove internal service file. It may not exist."
  rm -f "$SERVICES_DIR/$SERVICE_FILE_NAME" || echo "Failed to remove system level service file. It may not exist."
fi

echo "Finished removing garden device services."
