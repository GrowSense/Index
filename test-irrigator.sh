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

sh create-garden-irrigator.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT
