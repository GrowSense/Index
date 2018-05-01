MONITOR_LABEL="MyMonitor"
MONITOR_DEVICE_NAME="mymonitor"
MONITOR_PORT="ttyUSB0"

echo "----------" && \
echo "Testing monitor scripts" && \
echo "----------" && \

sh clean.sh

echo "" && \
echo "Creating garden monitor services" && \
echo "" && \

sh create-garden-monitor.sh $MONITOR_LABEL $MONITOR_DEVICE_NAME $MONITOR_PORT && \

echo "" && \
echo "----------" && \
echo "Checking results" && \
echo "----------" && \

sh verify-updater-service.sh "monitor" $MONITOR_DEVICE_NAME $MONITOR_PORT && \

sh verify-mqtt-bridge-service.sh "monitor" $MONITOR_DEVICE_NAME $MONITOR_PORT && \

sh verify-device-ui.sh 1 "monitor" $MONITOR_DEVICE_NAME $MONITOR_LABEL $MONITOR_PORT && \

echo "" && \
echo "----------" && \
echo "Cleaning up" && \
echo "----------" && \

sh remove-garden-device.sh $MONITOR_DEVICE_NAME && \

echo "Monitor test complete"