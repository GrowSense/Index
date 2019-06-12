DEPLOYMENT_NAME=$1

echo ""
echo "Checking deployment devices..."

if [ ! $DEPLOYMENT_NAME ]; then
  echo "Please provide the name of the deployment. Example 'dev', 'master', 'lts'"
  exit 1
fi

echo "Deployment name: $DEPLOYMENT_NAME"

DEPLOYMENT_INFO_DIR="tests/deployments/$DEPLOYMENT_NAME"

DEPLOYMENT_INFO_DEVICES_DIR="$DEPLOYMENT_INFO_DIR/devices"

for d in $DEPLOYMENT_INFO_DEVICES_DIR/* ; do
    echo ""
    DEVICE_NAME="${d##*/}"
    echo "Device name: $DEVICE_NAME"
    echo ""
    bash check-deployment-device.sh $DEPLOYMENT_NAME $DEVICE_NAME || exit 1
done

echo "Finished checking deployment devices"
echo ""
