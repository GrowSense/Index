git submodule update --init

DIR=$PWD

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
cd $DIR
