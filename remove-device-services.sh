echo ""
echo "Removing garden device services"
echo ""

DEVICE_NAME=$1

SYSTEMCTL_SCRIPT="systemctl.sh"

DEVICE_GROUP=$(cat "devices/$DEVICE_NAME/group.txt")

if [ "$DEVICE_GROUP" = "ui" ]; then
  echo "Stopping/disabling UI controller service" && \
  sh $SYSTEMCTL_SCRIPT stop greensense-ui-1602-$DEVICE_NAME.service
  sh $SYSTEMCTL_SCRIPT disable greensense-ui-1602-$DEVICE_NAME.service
  
  echo "Removing UI controller service" && \
  rm -f scripts/apps/Serial1602ShieldSystemUIController/svc/greensense-ui-1602-$DEVICE_NAME.service
else
  echo "Stopping/disabling MQTT bridge service" && \
  sh $SYSTEMCTL_SCRIPT stop greensense-mqtt-bridge-$DEVICE_NAME.service
  sh $SYSTEMCTL_SCRIPT disable greensense-mqtt-bridge-$DEVICE_NAME.service

  echo "Removing MQTT bridge service" && \
  rm -f scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/greensense-mqtt-bridge-$DEVICE_NAME.service

fi
