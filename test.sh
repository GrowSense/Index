echo "Testing the GreenSense index"

sh remove-garden-devices.sh && \

sh create-garden.sh && \
sh create-garden-monitor.sh Monitor1 monitor1 ttyUSB0 && \
sh create-garden-irrigator.sh Irrigator1 irrigator1 ttyUSB1 && \

sh remove-garden-device.sh monitor1 && \
sh remove-garden-device.sh irrigator1 && \

sh create-garden-monitor.sh Monitor1 monitor1 ttyUSB0 && \
sh create-garden-irrigator.sh Irrigator1 irrigator1 ttyUSB1 && \

sh remove-garden-devices.sh && \

sh disable-garden.sh

echo "Testing complete"

