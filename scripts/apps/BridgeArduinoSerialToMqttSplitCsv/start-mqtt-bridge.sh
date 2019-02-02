sh init.sh

echo "Launching mqtt bridge."

mono BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe $1 $2 $3 $4 $5 $6 $7 $8 $9
