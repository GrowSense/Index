echo "Initializing GreenSense index"

git submodule update --init

DIR=$PWD

cd scripts/apps/BridgeArduinoSerialToMqttSplitCsv/ && \
sh init.sh && \
cd $DIR && \

cd scripts/apps/GitDeployer/ && \
sh init.sh && \
cd $DIR && \

cd mobile/linearmqtt/ && \
sh init.sh && \
cd $DIR && \

echo "Initialization completed."
