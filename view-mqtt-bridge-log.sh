DEVICE_NAME=$1

if [ ! $DEVICE_NAME ]; then
  echo "Error: Please provide a device name as parameter"
else
  SERVICE_NAME="greensense-mqtt-bridge-$DEVICE_NAME.service"
  
  SUDO=""
  if [ ! "$(id -u)" -eq 0 ]; then
    if [ ! -f "is-mock-sudo.txt" ]; then
      SUDO='sudo'
    fi
  fi
  
  $SUDO journalctl -u $SERVICE_NAME
fi
