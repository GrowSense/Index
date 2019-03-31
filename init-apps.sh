DIR=$PWD

echo ""
echo "Initializing MQTT bridge utility"

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
sh init.sh || (echo "Failed to initialize MQTT bridge." && exit 1)
cd $DIR

echo ""
echo "Initializing UI controller"

cd scripts/apps/Serial1602ShieldSystemUIController/ && \
sh init.sh || (echo "Failed to initialize UI controller." && exit 1)
cd $DIR

#echo && \
#echo "Initializing updater (GitDeployer) utility" && \

#cd scripts/apps/GitDeployer/ && \
#sh init.sh || (echo "Failed to initialize updater (GitDeployer)." && exit 1)
#cd $DIR

echo "" && \
echo "Initializing linear MQTT dashboard UI related scripts" && \
cd mobile/linearmqtt/ && \
sh init.sh  || (echo "Failed to initialize Linear MQTT." && exit 1)
cd $DIR

echo "Done"
