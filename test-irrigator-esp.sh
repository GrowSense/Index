IRRIGATOR_LABEL="MyIrrigator"
IRRIGATOR_DEVICE_NAME="myirrigator"
IRRIGATOR_PORT="ttyUSB1"

echo "----------" && \
echo "Testing irrigator ESP8266 scripts" && \
echo "----------" && \

sh clean.sh

echo "" && \
echo "Creating garden irrigator ESP8266" && \
echo "" && \

sh create-garden-irrigator-esp.sh $IRRIGATOR_LABEL $IRRIGATOR_DEVICE_NAME $IRRIGATOR_PORT && \

echo "" && \
echo "----------" && \
echo "Checking results" && \
echo "----------" && \

# Skip MQTT bridge and updater service verification because they aren't used with the WiFi version

#sh verify-device-ui.sh 1 "irrigator" $IRRIGATOR_DEVICE_NAME $IRRIGATOR_LABEL $IRRIGATOR_PORT && \

#echo "" && \
#echo "----------" && \
#echo "Cleaning up" && \
#echo "----------" && \

#sh remove-garden-device.sh $IRRIGATOR_DEVICE_NAME && \

echo "Irrigator ESP8266 test complete"
