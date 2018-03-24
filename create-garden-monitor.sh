echo ""
echo "Creating garden monitor configuration"
echo ""

DIR=$PWD

DEVICE_NAME=$1
DEVICE_PORT=$2

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="monitor1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Set up MQTT bridge service
cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
cp svc/greensense-mqtt-bridge-monitor1.service.example svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \
sed -i "s/monitor1/$DEVICE_NAME/g" svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \
sed -i "s/ttyUSB0/$DEVICE_PORT/g" svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \
sh install-services.sh && \
cd $DIR && \

# Set up update service
cd scripts/apps/GitDeployer/ && \
cp svc/greensense-updater-monitor1.service.example svc/greensense-updater-$DEVICE_NAME.service && \
sed -i "s/ttyUSB0/$DEVICE_PORT/g" svc/greensense-updater-$DEVICE_NAME.service && \
sh install-services.sh && \
cd $DIR && \

# Upload sketch
cd sketches/monitor/SoilMoistureSensorCalibratedSerial
sh prepare.sh && \
sh init.sh && \
sh build.sh && \
sh upload.sh $DEVICE_PORT

echo "Garden monitor created with device name '$DEVICE_NAME'"
