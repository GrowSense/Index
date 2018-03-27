echo ""
echo "Creating garden irrigator configuration"
echo ""

# Example:
# sh create-garden-irrigator.sh [Label] [DeviceName] [Port]
# sh create-garden-irrigator.sh "Irrigator1" irrigator1 ttyUSB0 

DIR=$PWD

DEVICE_LABEL=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_LABEL ]; then
  DEVICE_LABEL="Monitor1"
fi

if [ ! $DEVICE_NAME ]; then
  DEVICE_NAME="monitor1"
fi

if [ ! $DEVICE_PORT ]; then
  DEVICE_PORT="ttyUSB0"
fi

echo "Device label: $DEVICE_LABEL"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

# Set up MQTT bridge service
cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
cp svc/greensense-mqtt-bridge-irrigator1.service.example svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \
sed -i "s/monitor1/$DEVICE_NAME/g" svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \
sed -i "s/ttyUSB0/$DEVICE_PORT/g" svc/greensense-mqtt-bridge-$DEVICE_NAME.service && \
sh install-services.sh && \
cd $DIR && \

# Set up update service
cd scripts/apps/GitDeployer/ && \
cp svc/greensense-updater-irrigator1.service.example svc/greensense-updater-$DEVICE_NAME.service && \
sed -i "s/ttyUSB0/$DEVICE_PORT/g" svc/greensense-updater-$DEVICE_NAME.service && \
sh install-services.sh && \
cd $DIR && \

# Set up mobile UI
cd mobile/linearmqtt/ && \
sh create-garden-irrigator-ui.sh $DEVICE_LABEL $DEVICE_NAME $DEVICE_PORT && \
cd $DIR

echo "Garden irrigator created with device name '$DEVICE_NAME'"
