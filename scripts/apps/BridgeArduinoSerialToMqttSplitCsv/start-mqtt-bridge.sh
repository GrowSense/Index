# Disabled because it shouldn't be needed. The package should already be initialised.
#sh init.sh

echo "Starting mqtt bridge..."

mono BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe $1 $2 $3 $4 $5 $6 $7 $8 $9
