DEPLOYMENT_NAME=$1

if [ ! $DEPLOYMENT_NAME ]; then
  echo "Please provide the name of the deployment. Example 'dev', 'master', 'lts'"
  exit 1
fi

echo ""
echo "Checking deployment devices..."
echo "  Deployment name: $DEPLOYMENT_NAME"

DEPLOYMENT_INFO_DIR="tests/deployments/$DEPLOYMENT_NAME"

DEPLOYMENT_INFO_DEVICES_DIR="$DEPLOYMENT_INFO_DIR/devices"

for d in $DEPLOYMENT_INFO_DEVICES_DIR/* ; do
    echo ""
    DEVICE_NAME="${d##*/}"
    bash check-deployment-device.sh $DEPLOYMENT_NAME $DEVICE_NAME
done
