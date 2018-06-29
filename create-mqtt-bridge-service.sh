echo "Creating MQTT bridge service file..."

DEVICE_TYPE=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! $DEVICE_TYPE ]; then
    echo "Specify device type as an argument."
    exit 1
fi

if [ ! $DEVICE_NAME ]; then
    echo "Specify device name as an argument."
    exit 1
fi

if [ ! $DEVICE_PORT ]; then
    echo "Specify device port as an argument."
    exit 1
fi

echo "Device type: $DEVICE_TYPE"
echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

SERVICE_EXAMPLE_FILE="greensense-mqtt-bridge-${DEVICE_TYPE}1.service.example"
SERVICE_FILE="greensense-mqtt-bridge-$DEVICE_NAME.service"
SERVICE_PATH="scripts/apps/BridgeArduinoSerialToMqttSplitCsv/svc"
SERVICE_FILE_PATH="$SERVICE_PATH/$SERVICE_FILE"
SERVICE_EXAMPLE_FILE_PATH="$SERVICE_PATH/$SERVICE_EXAMPLE_FILE"

echo "Example file:"
echo "$SERVICE_EXAMPLE_FILE_PATH"
echo "Service file:"
echo "$SERVICE_FILE_PATH"

echo "Copying service file..."

cp $SERVICE_EXAMPLE_FILE_PATH $SERVICE_FILE_PATH && \

echo "Editing service file..."
sed -i "s/${DEVICE_TYPE}1/$DEVICE_NAME/g" $SERVICE_FILE_PATH && \
sed -i "s/ttyUSB[0-9]/$DEVICE_PORT/g" $SERVICE_FILE_PATH && \

echo "Installing service..."
sh install-service.sh $SERVICE_FILE_PATH && \

echo "Finished creating MQTT bridge service"
