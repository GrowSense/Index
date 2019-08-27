echo "Creating 1602 LCD shield UI controller file..."

DEVICE_NAME=$1
DEVICE_PORT=$2

if [ ! $DEVICE_NAME ]; then
    echo "Specify device name as an argument."
    exit 1
fi

if [ ! $DEVICE_PORT ]; then
    echo "Specify device port as an argument."
    exit 1
fi

echo "Device name: $DEVICE_NAME"
echo "Device port: $DEVICE_PORT"

SERVICE_EXAMPLE_FILE="greensense-ui-1602.service.template"
SERVICE_FILE="greensense-ui-1602-$DEVICE_NAME.service"
SERVICE_PATH="scripts/apps/Serial1602ShieldSystemUIController/svc"
SERVICE_FILE_PATH="$SERVICE_PATH/$SERVICE_FILE"
SERVICE_EXAMPLE_FILE_PATH="$SERVICE_PATH/$SERVICE_EXAMPLE_FILE"

BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

echo "Branch: $BRANCH"

echo "Example file:"
echo "$SERVICE_EXAMPLE_FILE_PATH"
echo "Service file:"
echo "$SERVICE_FILE_PATH"

echo "Copying service file..."

cp $SERVICE_EXAMPLE_FILE_PATH $SERVICE_FILE_PATH && \

echo "Editing service file..."
sed -i "s/{DEVICE_NAME}/$DEVICE_NAME/g" $SERVICE_FILE_PATH && \
sed -i "s/{PORT}/$DEVICE_PORT/g" $SERVICE_FILE_PATH && \
sed -i "s/{BRANCH}/$BRANCH/g" $SERVICE_FILE_PATH && \

echo "Installing service..."
bash install-service.sh $SERVICE_FILE_PATH && \

echo "Finished creating 1602 LCD shield UI controller service"
