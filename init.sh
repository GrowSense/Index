echo "Initializing GreenSense index"

sh update-submodules.sh

DIR=$PWD

echo "Index unit tests" && \

cd tests/nunit/ && \
sh init.sh && \
cd $DIR && \

echo "MQTT bridge" && \

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
sh init.sh && \
cd $DIR && \

echo "Updater" && \

cd scripts/apps/GitDeployer/ && \
sh init.sh && \
cd $DIR && \

echo "Linear MQTT dashboard" && \
cd mobile/linearmqtt/ && \
sh init.sh && \
cd $DIR && \

echo "Initialization completed."
