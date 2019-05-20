echo ""
echo "Restarting all garden services"
echo ""

DIR=$PWD

sh restart-supervisor.sh || exit 1

# Only restart the MQTT service if the MQTT host is localhost, otherwise it's not installed/running
MQTT_HOST=$(cat mqtt-host.security)
if [ "$MQTT_HOST" = "localhost" ] || [ "$MQTT_HOST" = "127.0.0.1" ]; then
  sh restart-mqtt.sh || exit 1
fi

DEVICES_DIR="devices"

if [ -d "$DEVICES_DIR" ]; then
    for d in $DEVICES_DIR/*; do
        DEVICE_NAME=$(cat $d/name.txt)
        DEVICE_LABEL=$(cat $d/label.txt)        
        
        echo "$DEVICE_LABEL"
        
        sh restart-garden-device.sh $DEVICE_NAME
       
        echo ""
    done
else
    echo "No device info found in $DEVICES_DIR"
fi
