echo "Creating Plug and Play service file..."

SERVICE_EXAMPLE_FILE="greensense-plug-and-play.service.example"
SERVICE_FILE="greensense-plug-and-play.service"
SERVICE_PATH="scripts/apps/ArduinoPlugAndPlay/svc"
SERVICE_FILE_PATH="$SERVICE_PATH/$SERVICE_FILE"
SERVICE_EXAMPLE_FILE_PATH="$SERVICE_PATH/$SERVICE_EXAMPLE_FILE"

echo "Example file:"
echo "$SERVICE_EXAMPLE_FILE_PATH"
echo "Service file:"
echo "$SERVICE_FILE_PATH"

echo "Copying service file..."

cp $SERVICE_EXAMPLE_FILE_PATH $SERVICE_FILE_PATH && \

echo "Service file:"
echo "$SERVICE_FILE_PATH"

#echo "Editing service file..."
#sed -i "s/${DEVICE_TYPE}1/$DEVICE_NAME/g" $SERVICE_FILE_PATH && \
#sed -i "s/ttyUSB[0-9]/$DEVICE_PORT/g" $SERVICE_FILE_PATH && \


echo "Installing service..."
sh install-service.sh $SERVICE_FILE_PATH && \

echo "Finished creating arduino plug and play service"
