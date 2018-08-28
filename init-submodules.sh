git submodule update --init

DIR=$PWD

echo "SoilMoistureSensorCalibratedSerial" && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerial/ && \
sh init.sh && \
cd $DIR && \

echo "SoilMoistureSensorCalibratedSerialESP" && \

cd sketches/monitor/SoilMoistureSensorCalibratedSerialESP/ && \
sh init.sh && \
cd $DIR && \

echo "SoilMoistureSensorCalibratedPump" && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPump/ && \
sh init.sh && \
cd $DIR && \

echo "SoilMoistureSensorCalibratedPumpESP" && \

cd sketches/irrigator/SoilMoistureSensorCalibratedPumpESP/ && \
sh init.sh && \
cd $DIR
