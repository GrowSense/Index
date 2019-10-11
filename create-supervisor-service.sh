echo "Creating GrowSense system supervisor service..."

SERVICE_EXAMPLE_FILE="greensense-supervisor.service.example"
SERVICE_FILE="greensense-supervisor.service"
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
bash install-service.sh $SERVICE_FILE_PATH && \

echo "Finished GrowSense system supervisor service"
