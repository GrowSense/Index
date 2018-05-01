IRRIGATOR_LABEL="MyIrrigator"
IRRIGATOR_DEVICE_NAME="myirrigator"
IRRIGATOR_PORT="ttyUSB1"

echo "----------" && \
echo "Testing irrigator scripts" && \
echo "----------" && \

sh clean.sh

echo "" && \
echo "Creating garden irrigator services" && \
echo "" && \

sh create-garden-irrigator.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \

echo "" && \
echo "----------" && \
echo "Checking results" && \
echo "----------" && \

sh verify-updater-service.sh "irrigator" $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \

sh verify-mqtt-bridge-service.sh "irrigator" $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \

sh verify-device-ui.sh 1 "irrigator" $IRRIGATOR_DEVICE_NAME $IRRIGATOR_LABEL $IRRIGATOR_PORT && \

echo "" && \
echo "----------" && \
echo "Cleaning up" && \
echo "----------" && \

sh remove-garden-device.sh $IRRIGATOR_DEVICE_NAME && \

echo "Irrigator test complete"