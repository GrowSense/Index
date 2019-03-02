echo "Initializing GreenSense index"

echo "" && \
echo "Initializing MQTT bridge utility" && \

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
sh init.sh && \
cd $DIR && \

echo && \
echo "Initializing updater (GitDeployer) utility" && \

cd scripts/apps/GitDeployer/ && \
sh init.sh && \
cd $DIR && \

echo "" && \
echo "Initializing linear MQTT dashboard UI related scripts" && \
cd mobile/linearmqtt/ && \
sh init.sh && \
cd $DIR && \

echo "Initialization completed."
