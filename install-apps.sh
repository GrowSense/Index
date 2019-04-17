echo "Installing required apps..."

DIR=$PWD

echo "Installing system UI controller..."

cd scripts/apps/Serial1602ShieldSystemUIController
sh install.sh
cd $DIR

echo "Installing MQTT bridge..."

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv
sh install.sh
cd $DIR

echo "Finished installing required apps."


