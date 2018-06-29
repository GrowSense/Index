MONITOR_LABEL="MyMonitor"
MONITOR_DEVICE_NAME="mymonitor"
MONITOR_PORT="ttyUSB0"

echo "----------" && \
echo "Testing monitor scripts" && \
echo "----------" && \

sh clean.sh && \
sh remove-garden-devices.sh && \

echo "" && \
echo "Creating garden monitor services" && \
echo "" && \

sh create-garden-monitor.sh $MONITOR_LABEL $MONITOR_DEVICE_NAME $MONITOR_PORT
