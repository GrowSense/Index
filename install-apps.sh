echo "Installing required apps..."

DIR=$PWD

cd scripts/apps/Serial1602ShieldSystemUIController
sh install.sh
cd $DIR

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv
sh install.sh
cd $DIR

echo "Finished installing required apps."


