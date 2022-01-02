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

if [ ! -d "devices/$DEVICE_NAME" ]; then
  echo "  Error: Device info directory not found."
  exit 1
fi

CURRENT_HOST=$(cat /etc/hostname)

echo "  Device type: $DEVICE_TYPE"
echo "  Device name: $DEVICE_NAME"
echo "  Device port: $DEVICE_PORT"

DEVICE_HOST=$(cat devices/$DEVICE_NAME/host.txt) || exit 1
echo "  Device host: $DEVICE_HOST"

DEVICE_IS_USB_CONNECTED=1
if [ -f "devices/$DEVICE_NAME/is-usb-connected.txt" ]; then
   DEVICE_IS_USB_CONNECTED=$(cat devices/$DEVICE_NAME/is-usb-connected.txt) || exit 1
fi
echo "  Device is connected via USB: $DEVICE_IS_USB_CONNECTED"

if [ "$DEVICE_HOST" != "$CURRENT_HOST" ]; then
  echo "  Device is on another host. Skipping service creation...."
  exit 0
elif [ "$DEVICE_IS_USB_CONNECTED" = "0" ]; then
  echo "  Device is not connected via USB. Skipping service creation..."
  exit 0
fi

SERVICE_EXAMPLE_FILE="growsense-mqtt-bridge-${DEVICE_TYPE}1.service.example"
SERVICE_FILE="growsense-mqtt-bridge-$DEVICE_NAME.service"
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
sed -i "s/{IndexPath}/$PWD/g" $SERVICE_FILE_PATH && \

cat $SERVICE_FILE_PATH
exit 0
echo "Installing service..."
bash install-service.sh $SERVICE_FILE_PATH && \

echo "Finished creating MQTT bridge service"
