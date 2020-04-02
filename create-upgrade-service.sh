echo "Creating GrowSense system upgrade service..."

SERVICE_EXAMPLE_FILE="growsense-upgrade.service.example"
SERVICE_FILE="growsense-upgrade.service"
SERVICE_PATH="svc"
SERVICE_FILE_PATH="$SERVICE_PATH/$SERVICE_FILE"
SERVICE_EXAMPLE_FILE_PATH="$SERVICE_PATH/$SERVICE_EXAMPLE_FILE"

echo "Example file:"
echo "$SERVICE_EXAMPLE_FILE_PATH"
echo "Service file:"
echo "$SERVICE_FILE_PATH"

echo "Copying service file..."

cp $SERVICE_EXAMPLE_FILE_PATH $SERVICE_FILE_PATH || exit 1

echo "Service file:"
echo "$SERVICE_FILE_PATH"

echo "Installing service..."
bash install-service.sh $SERVICE_FILE_PATH 0 || exit 1

echo "Disabling service so it doesn't start unless triggered by supervisor..."
bash systemctl.sh disable $SERVICE_FILE

echo "Finished GrowSense system upgrade service"
