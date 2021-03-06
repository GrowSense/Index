DIR=$PWD

echo ""
echo "Initializing MQTT bridge utility"

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
sh init.sh || exit 1
cd $DIR

echo ""
echo "Initializing UI controller"

cd scripts/apps/Serial1602ShieldSystemUIController/ && \
sh init.sh || exit 1
cd $DIR

# TODO: Remove if not needed. Should be obsolete. Linear MQTT Dashboard is being phased out.
#echo "" && \
#echo "Initializing linear MQTT dashboard UI related scripts" && \
#cd mobile/linearmqtt/ && \
#sh init.sh || exit 1
#cd $DIR

echo "Done"
