echo ""
echo "Removing garden device services"
echo ""

DIR=$PWD

SYSTEMCTL_SCRIPT="systemctl.sh"

SUDO=""
if [ ! "$(id -u)" -eq 0 ]; then
    SUDO='sudo'
fi

echo ""
echo "Device Info"
echo ""

for DEVICE_DIR in devices/*; do
  if [ -d $DEVICE_DIR ]; then
    DEVICE_NAME=$(basename $DEVICE_DIR)
    echo "  $DEVICE_NAME"
    bash remove-garden-device.sh $DEVICE_NAME
  fi
done

echo "Finished removing garden device services"
