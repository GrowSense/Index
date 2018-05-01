SERVICE_FILE_PATH=$1
SERVICE_FILE=$(basename -- "$SERVICE_FILE_PATH")

echo "Installing service"
echo "Path: $SERVICE_FILE_PATH"
echo "Name: $SERVICE_FILE"

SYSTEMCTL_SCRIPT="systemctl.sh"

sudo cp -fv $SERVICE_FILE_PATH /lib/systemd/system/$SERVICE_FILE
sudo chmod 644 /lib/systemd/system/$SERVICE_FILE
sudo sh $SYSTEMCTL_SCRIPT daemon-reload
sudo sh $SYSTEMCTL_SCRIPT enable $SERVICE_FILE
sudo sh $SYSTEMCTL_SCRIPT restart $SERVICE_FILE

echo "Finished installing service"