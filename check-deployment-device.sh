DEPLOYMENT_NAME=$1
DEVICE_NAME=$2

EXAMPLE="Syntax:\n  *.sh [DeploymentName] [DeviceName]\nExample:\n  *.sh dev irrigator1"  

echo "Checking deployment device..."

if [ ! $DEPLOYMENT_NAME ]; then
  echo "Please provide the name of the deployment as an argument."
  echo "$EXAMPLE"
  exit 1
fi

if [ ! $DEVICE_NAME ]; then
  echo "Please provide the name of the deployment."
  echo "$EXAMPLE"
  exit 1
fi

DEPLOYMENT_DEVICE_INFO_DIR="tests/deployments/$DEPLOYMENT_NAME/devices/$DEVICE_NAME"

# Detect the deployment details
. ./detect-deployment-details.sh || exit 1

DEVICE_GROUP=$(cat "$DEPLOYMENT_DEVICE_INFO_DIR/group.txt") || exit 1
DEVICE_CONNECTION=$(cat "$DEPLOYMENT_DEVICE_INFO_DIR/connection.txt") || exit 1

echo "  Device name: $DEVICE_NAME"
echo "  Device group: $DEVICE_GROUP"
echo "  Device connection: $DEVICE_CONNECTION"
echo "  Device info dir: $DEPLOYMENT_DEVICE_INFO_DIR"

SERVICE_NAME="greensense-mqtt-bridge-$DEVICE_NAME.service"
SERVICE_LABEL="MQTT bridge"

if [ "$DEVICE_GROUP" = "ui" ]; then
  SERVICE_NAME="greensense-ui-1602-$DEVICE_NAME.service"
  SERVICE_LABEL="UI controller"
fi

if [ "$DEVICE_CONNECTION" = "usb" ]; then
  echo "Connection type is USB. Checking services..."
  echo ""
  echo "Viewing $SERVICE_LABEL log..."

  SERVICE_LOG=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "journalctl -u $SERVICE_NAME -b | tail -n 100")

  echo "${SERVICE_LOG}"

  [[ $(echo $SERVICE_LOG) =~ "Connected to MQTT" ]] && echo "The $DEVICE_NAME $SERVICE_LABEL service failed to connect to MQTT broker" && exit 1

  echo ""
  echo "Viewing $SERVICE_LABEL service status..."
  SERVICE_STATUS=$(sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "systemctl status $SERVICE_NAME")

  echo "${SERVICE_STATUS}"

  [[ ! $(echo $SERVICE_STATUS) =~ "Loaded: loaded" ]] && echo "The $DEVICE_NAME $SERVICE_LABEL service isn't loaded" && exit 1
  [[ ! $(echo $SERVICE_STATUS) =~ "Active: active" ]] && echo "The $DEVICE_NAME $SERVICE_LABEL service isn't active" && exit 1
  [[ $(echo $SERVICE_STATUS) =~ "not found" ]] && echo "The $DEVICE_NAME $SERVICE_LABEL service wasn't found" && exit 1
  
  
else
  echo "  Connection type is $DEVICE_CONNECTION. Skipping service check."
fi

echo "Finished checking deployment device"
echo ""

