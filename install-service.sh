SERVICE_FILE_PATH=$1
SERVICE_FILE=$(basename -- "$SERVICE_FILE_PATH")

echo "Installing service"
echo "Path: $SERVICE_FILE_PATH"
echo "Name: $SERVICE_FILE"

SYSTEMCTL_SCRIPT="systemctl.sh"

MOCK_SYSTEMCTL_FLAG_FILE="is-mock-systemctl.txt"

IS_MOCK_SYSTEMCTL=0

if [ -f "$MOCK_SYSTEMCTL_FLAG_FILE" ]; then
  IS_MOCK_SYSTEMCTL=1
  echo "Is mock systemctl"
fi

SERVICES_DIR="/lib/systemd/system"

if [ $IS_MOCK_SYSTEMCTL = 1 ]; then
  SERVICES_DIR="mock/services"
fi

mkdir -p $SERVICES_DIR

echo "Services directory:"
echo "  $SERVICES_DIR"
echo "Destination file:"
echo "  $SERVICES_DIR/$SERVICE_FILE"

if [ $IS_MOCK_SYSTEMCTL = 1 ]; then
  echo "Is mock systemctl. Installing to mock directory."
  cp $SERVICE_FILE_PATH $SERVICES_DIR/$SERVICE_FILE
else
  sudo cp -fv $SERVICE_FILE_PATH $SERVICES_DIR/$SERVICE_FILE && \
  sudo chmod 644 $SERVICES_DIR/$SERVICE_FILE && \
  sudo sh $SYSTEMCTL_SCRIPT daemon-reload && \
  sudo sh $SYSTEMCTL_SCRIPT enable $SERVICE_FILE && \
  sudo sh $SYSTEMCTL_SCRIPT start $SERVICE_FILE && \
  sudo sh $SYSTEMCTL_SCRIPT restart $SERVICE_FILE
fi

echo "Finished installing service"
