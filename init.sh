echo "Initializing GreenSense index"

git submodule update --init

DIR=$PWD

cd tests/nunit/ && \
sh init.sh && \
cd $DIR && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerial/ && \
sh init.sh && \
cd $DIR && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/ && \
sh init.sh && \
cd $DIR && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPump/ && \
sh init.sh && \
cd $DIR && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP/ && \
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
