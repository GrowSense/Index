
INIT_SCRIPT_FILE_URL="https://raw.githubusercontent.com/GreenSense/Index/master/scripts/apps/BridgeArduinoSerialToMqttSplitCsv/init.sh"
wget -O init.sh $INIT_SCRIPT_FILE_URL

sh init.sh || exit 1

mono BridgeArduinoSerialToMqttSplitCsv/lib/net40/BridgeArduinoSerialToMqttSplitCsv.exe $1 $2 $3 $4 $5 $6 $7 $8 $9
