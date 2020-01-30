echo "Creating GrowSense network reconnect service..."

SERVICE_EXAMPLE_FILE="growsense-network-reconnect.service.example"
SERVICE_FILE="growsense-network-reconnect.service"
SERVICE_PATH="svc"
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

echo "Installing service..."
bash install-service.sh $SERVICE_FILE_PATH 0 && \

bash systemctl.sh stop $SERVICE_FILE && \
bash systemctl.sh disable $SERVICE_FILE && \

echo "Finished GrowSense network reconnect service"
