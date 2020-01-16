# Disabled because it shouldn't be needed. The package should already be initialised.
#sh init.sh

echo "Starting mqtt bridge..."

mono BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe $1 $2 $3 $4 $5 $6 $7 $8 $9 || (echo "MQTT bridge error. Retrying in 5 seconds..." && sleep 5 && bash start-mqtt-bridge.sh $1 $2 $3 $4 $5 $6 $7 $8 $9)
