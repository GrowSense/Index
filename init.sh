echo "Initializing GreenSense index"

sh update-submodules.sh

DIR=$PWD

cd tests/nunit/ && \
sh init.sh && \
cd $DIR && \

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
