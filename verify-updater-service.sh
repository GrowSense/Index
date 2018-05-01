echo "Verifying updater service files have been created..."

DEVICE_TYPE=$1
DEVICE_NAME=$2
DEVICE_PORT=$3

if [ ! "$DEVICE_TYPE" ]; then
    echo "Specify the device type as an argument."
    exit 1
fi

if [ ! "$DEVICE_NAME" ]; then
    echo "Specify the device name as an argument."
    exit 1
fi

if [ ! "$DEVICE_PORT" ]; then
    echo "Specify the device port as an argument."
    exit 1
fi

SERVICE_FILE="/lib/systemd/system/greensense-updater-$DEVICE_NAME.service" && \

echo "Checking service file exists..."

if [ ! -f "$SERVICE_FILE" ]; then
    echo "Updater service file not found at:" && \
    echo "$SERVICE_FILE" && \
    exit 1
else
    echo "Updater service file found:" && \
    echo "$SERVICE_FILE"
fi

echo "Service file:"
echo "----------"
cat $SERVICE_FILE
echo "----------"

echo "Checking service file is valid..." && \

echo "Checking service file contains the right device name..." && \
if ! grep -q "$DEVICE_NAME" $SERVICE_FILE; then
    echo "  Device name not found: $DEVICE_NAME"
    cat $SERVICE_FILE
    exit 1
else
    echo "  Device name found: $DEVICE_NAME"
fi

echo "Checking service file contains the right port..." && \
if ! grep -q "$DEVICE_PORT" $SERVICE_FILE; then
    echo "  Port not found: $DEVICE_PORT"
    exit 1
else
    echo "  Port found: $DEVICE_PORT"
fi

echo "Checking service file contains the right project name..." && \
FULL_PROJECT_NAME=""
if [ "$DEVICE_TYPE" = "monitor" ]; then
    FULL_PROJECT_NAME="SoilMoistureSensorCalibratedSerial"
fi
if [ "$DEVICE_TYPE" = "irrigator" ]; then
    FULL_PROJECT_NAME="SoilMoistureSensorCalibratedPump"
fi

if ! grep -q "$FULL_PROJECT_NAME" $SERVICE_FILE; then
    echo "  Full project name not found: $FULL_PROJECT_NAME"
    exit 1
else
    echo "  Full project name found: $FULL_PROJECT_NAME"
fi

echo "Verification complete"