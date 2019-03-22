echo ""
echo "Removing garden device services"
echo ""

DEVICE_NAME=$1

SYSTEMCTL_SCRIPT="systemctl.sh"

echo "Stopping/disabling MQTT bridge service" && \
sh $SYSTEMCTL_SCRIPT stop greensense-mqtt-bridge-$DEVICE_NAME.service
sh $SYSTEMCTL_SCRIPT disable greensense-mqtt-bridge-$DEVICE_NAME.service

echo "Removing MQTT bridge service" && \
rm -f scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc/greensense-mqtt-bridge-$DEVICE_NAME.service

echo "Stopping/disabling service" && \
sh $SYSTEMCTL_SCRIPT stop greensense-updater-$DEVICE_NAME.service
sh $SYSTEMCTL_SCRIPT disable greensense-updater-$DEVICE_NAME.service

echo "Removing updater service" && \
rm -f scripts/apps/GitDeployer/svc/greensense-updater-$DEVICE_NAME.service
